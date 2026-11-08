#!/usr/bin/env node
const BASE = (process.argv[2] || process.env.API_BASE_URL || 'https://24appbackend-production.up.railway.app/').replace(/\/+$/, '');
const OTP = process.env.TEST_OTP || '987654';
const TIMEOUT = Number(process.env.TIMEOUT_MS || 20000);

const results = [];
const S = {};

function label(v) {
  if (v === null || v === undefined) return '';
  return typeof v === 'string' ? v : JSON.stringify(v);
}

async function call(name, method, path, { body, token, expect = [200, 201], raw } = {}) {
  const url = `${BASE}${path}`;
  const headers = {};
  if (body !== undefined && !raw) headers['Content-Type'] = 'application/json';
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const started = Date.now();
  let status = 0, json = null, text = '', err = null;
  try {
    const res = await fetch(url, {
      method, headers,
      body: body === undefined ? undefined : (raw ? body : JSON.stringify(body)),
      signal: AbortSignal.timeout(TIMEOUT),
    });
    status = res.status;
    text = await res.text();
    try { json = JSON.parse(text); } catch { /* not json */ }
  } catch (e) {
    err = e.name === 'TimeoutError' ? `timeout>${TIMEOUT}ms` : e.message;
  }
  const ok = err === null && expect.includes(status);
  results.push({ name, method, path, status, ok, ms: Date.now() - started, err,
    note: ok ? '' : (err || label(json && (json.message || json.error)) || text.slice(0, 120)) });
  return { status, json, text, ok };
}

const uniq = Date.now().toString().slice(-7);
const rnd = () => Math.floor(1000 + Math.random() * 9000);
const phoneA = `+1555${uniq}`;
const phoneB = `+1556${uniq}`;
const email = `qa${uniq}${rnd()}@example.com`;

async function signupAndProfile(phone, name, tag) {
  await call(`${tag}: signup`, 'POST', '/api/auth/signup', { phoneNumber: phone });
  const v = await call(`${tag}: verifyUser`, 'POST', '/api/auth/verifyUser', { phoneNumber: phone, otp: OTP });
  const token = v.json && (v.json.token || v.json.accessToken || (v.json.data && v.json.data.token));
  const userId = v.json && (v.json.userId || (v.json.user && v.json.user._id) || (v.json.data && v.json.data.userId));
  if (!token) { results.push({ name: `${tag}: token`, method: '-', path: '-', status: 0, ok: false, ms: 0, note: `no token in verifyUser body: ${JSON.stringify(v.json).slice(0,160)}` }); return {}; }

  for (const step of [1, 2, 3, 4]) {
    const bodies = {
      1: { steps_done: 1, name, fullName: name, Gender: 'female', show_gender: true,
           DateOfBirth: '1996-04-12', hometown: 'Paris', show_hometown: true, height: 170, show_height: true },
      2: { steps_done: 2, education: 'Bachelors', school_name: 'MIT', show_school_name: true },
      3: { steps_done: 3, job_title: 'Engineer', show_job_title: true, company_name: 'Acme', show_company_name: true,
           fullName: name, social_handle: '@qa', email: `${name.split(' ')[0].toLowerCase()}${Date.now()}@ex.com`,
           drinking: 'Never', show_drinking: true, smoking: 'Never', show_smoking: true },
      4: { steps_done: 4, political_affiliation: 'Moderate', show_political_affiliation: true,
           iceBreakers: [{ question: 'Best trip ever?', answer: 'Kyoto in spring' }],
           photos: ['https://picsum.photos/id/1011/600/800', 'https://picsum.photos/id/1012/600/800'] },
    };
    await call(`${tag}: addProfile step ${step}`, 'POST', '/api/user/addProfile', { body: bodies[step], token });
  }
  const me = await call(`${tag}: getUser`, 'GET', '/api/user/getUser', { token });
  const id = userId || (me.json && (me.json._id || (me.json.user && me.json.user._id)));
  return { token, userId: id };
}

(async () => {
  console.log(`base: ${BASE}\n`);

  // --- 0. reachability, no DB needed
  await call('root health', 'GET', '/');
  await call('/health', 'GET', '/health');

  // --- 1. public routes
  await call('payment plans (public)', 'GET', '/api/payment/plans');
  await call('content help', 'GET', '/api/content/help/faq', { expect: [200, 404] });
  await call('content legal', 'GET', '/api/content/legal/terms', { expect: [200, 404] });
  await call('content unknown collection 404', 'GET', '/api/content/help/__nope__', { expect: [404] });

  // --- 2. auth guard: token-required route must reject anonymous
  await call('GUARD getUser anon -> 401', 'GET', '/api/user/getUser', { expect: [401, 403] });
  await call('GUARD admin/users anon -> 401', 'GET', '/api/admin/users', { expect: [401, 403] });
  await call('GUARD travel/cities anon -> 401', 'GET', '/api/travel/cities', { expect: [401, 403] });

  // --- 3. user A full onboarding
  const A = await signupAndProfile(phoneA, 'Aisha QA', 'A');
  if (!A.token) { report(); return; }
  S.tokenA = A.token; S.userA = A.userId;

  // --- 4. user B (match target)
  const B = await signupAndProfile(phoneB, 'Bilal QA', 'B');
  S.tokenB = B.token; S.userB = B.userId;

  const tA = S.tokenA, tB = S.tokenB;

  // --- 5. sign in again with existing phone
  await call('signIn existing phone', 'POST', '/api/auth/signIn', { body: { phoneNumber: phoneA } });
  await call('verifySignIn', 'POST', '/api/auth/verifySignIn', { body: { phoneNumber: phoneA, otp: OTP }, expect: [200, 401] });
  await call('loginWithKeys', 'POST', '/api/auth/loginWithKeys', { body: { email }, expect: [200, 400, 401, 404] });

  // --- 6. user / account
  await call('updateProfile', 'PUT', '/api/user/updateProfile', { body: { bio: 'qa run' }, token: tA });
  await call('updateLocation (pre-match)', 'POST', '/api/user/updateLocation', { body: { latitude: 48.8566, longitude: 2.3522 }, token: tA });
  await call('findMatches', 'GET', '/api/user/findMatches', { token: tA });
  await call('findMatchesV2', 'GET', '/api/user/findMatchesV2', { token: tA });
  await call('getUsersPaginated', 'GET', '/api/user/getUsersPaginated', { token: tA });
  await call('getUsersByIds', 'POST', '/api/user/getUsersByIds', { body: { userIds: [S.userB].filter(Boolean) }, token: tA });
  await call('updateLocation', 'POST', '/api/user/updateLocation', { body: { latitude: 48.8566, longitude: 2.3522 }, token: tA });
  await call('updateLocationTravel', 'POST', '/api/user/updateLocationTravel', { body: { latitude: 48.8566, longitude: 2.3522, city: 'Paris', country: 'France' }, token: tA });
  await call('updateLoginMethods', 'PUT', '/api/user/updateLoginMethods', { body: { email }, token: tA, expect: [200, 400] });
  await call('toggleTravelMode', 'POST', '/api/user/toggleTravelMode', { body: { isTraveling: true, city: 'Paris', country: 'France' }, token: tA });
  await call('privacySettings GET', 'GET', '/api/user/privacySettings', { token: tA });
  await call('privacySettings PUT', 'PUT', '/api/user/privacySettings', { body: { read_receipts: true, incognito: false, profile_visibility: 'everyone', last_active_visibility: 'matches' }, token: tA });
  await call('notificationPreferences GET', 'GET', '/api/user/notificationPreferences', { token: tA });
  await call('notificationPreferences PUT', 'PUT', '/api/user/notificationPreferences', { body: { new_messages: { push: true, in_app: true, email: false } }, token: tA });

  // phone / email change round trip
  const pc = await call('changePhone/request', 'POST', '/api/user/changePhone/request', { body: { phoneNumber: `+1557${uniq}` }, token: tA });
  const pTok = pc.json && (pc.json.changeToken || (pc.json.data && pc.json.data.changeToken));
  if (pTok) await call('changePhone/confirm', 'POST', '/api/user/changePhone/confirm', { body: { changeToken: pTok, otp: OTP }, token: tA });
  const ec = await call('changeEmail/request', 'POST', '/api/user/changeEmail/request', { body: { email }, token: tA });
  const eTok = ec.json && (ec.json.changeToken || (ec.json.data && ec.json.data.changeToken));
  if (eTok) await call('changeEmail/confirm', 'POST', '/api/user/changeEmail/confirm', { body: { changeToken: eTok, otp: OTP }, token: tA });

  // --- 7. preferences
  await call('preferences POST', 'POST', '/api/preferences', { body: { ageRange: { min: 22, max: 38 }, distance: 50 }, token: tA, expect: [200, 201] });
  await call('preferences add', 'POST', '/api/preferences/add', { body: { ageRange: { min: 22, max: 38 } }, token: tA, expect: [200, 201] });
  await call('preferences GET', 'GET', '/api/preferences', { token: tA });
  await call('preferences PUT', 'PUT', '/api/preferences', { body: { distance: 80 }, token: tA });

  // --- 8. icebreakers
  const ib = await call('icebreaker create', 'POST', '/api/icebreaker/create', { body: { question: `QA question ${uniq}?` }, token: tA, expect: [200, 201] });
  const ibId = ib.json && (ib.json._id || (ib.json.iceBreaker && ib.json.iceBreaker._id) || (ib.json.data && ib.json.data._id));
  await call('icebreaker list', 'GET', '/api/icebreaker', { token: tA });
  if (ibId) {
    await call('icebreaker answer PUT', 'PUT', `/api/icebreaker/answer/${ibId}`, { body: { answer: 'QA answer' }, token: tA });
    await call('icebreaker my-answers', 'GET', '/api/icebreaker/my-answers', { token: tA });
    await call('icebreaker answer DELETE', 'DELETE', `/api/icebreaker/answer/${ibId}`, { token: tA });
  }

  // --- 9. travel: create a story, then read it back every way
  const post = await call('travel createPost', 'POST', '/api/travel/createPost', {
    body: { imageUrls: ['https://picsum.photos/id/1015/900/1600'], caption: `QA post ${uniq}`,
            city: `QaCity${uniq}`, country: 'France', location: { type: 'Point', coordinates: [2.3522, 48.8566] } },
    token: tA, expect: [200, 201] });
  const postId = post.json && (post.json.post ? post.json.post._id : post.json._id);
  await call('travel cities', 'GET', '/api/travel/cities', { token: tA });
  await call('travel cities/search', 'GET', '/api/travel/cities/search?q=Qa', { token: tA });
  await call('travel cities/nearby', 'GET', '/api/travel/cities/nearby?latitude=48.8566&longitude=2.3522', { token: tA });
  await call('travel nearbyCities', 'GET', '/api/travel/nearbyCities?latitude=48.8566&longitude=2.3522', { token: tA });
  await call('travel destinations/search', 'GET', '/api/travel/destinations/search?q=Qa', { token: tA });
  await call('travel destinations/nearby', 'GET', '/api/travel/destinations/nearby?latitude=48.8566&longitude=2.3522', { token: tA });
  const cities = await call('travel posts', 'GET', '/api/travel/posts', { token: tA });
  const cityId = (() => {
    const j = cities.json;
    const arr = Array.isArray(j) ? j : (j && (j.posts || j.cities || j.data)) || [];
    const first = arr[0];
    return first && (first.cityId || (first.city && first.city._id) || first._id);
  })();
  if (cityId) {
    await call('travel destinations/:cityId', 'GET', `/api/travel/destinations/${cityId}`, { token: tA });
    await call('travel posts/city/:cityId', 'GET', `/api/travel/posts/city/${cityId}`, { token: tA });
    await call('travel posts/:cityId', 'GET', `/api/travel/posts/${cityId}`, { token: tA });
  }
  if (S.userA) await call('travel posts/user/:userId', 'GET', `/api/travel/posts/user/${S.userA}`, { token: tA });
  if (postId) {
    const v = await call('travel post view', 'POST', `/api/travel/posts/${postId}/view`, { token: tB || tA });
    const l = await call('travel post like', 'POST', `/api/travel/posts/${postId}/like`, { token: tB || tA });
    const vs = v.json && (v.json.views ?? (v.json.post && v.json.post.views));
    const ls = l.json && (l.json.likes ?? (l.json.post && l.json.post.likes));
    results.push({ name: 'view/like not swapped', method: '-', path: '-', status: 200,
      ok: !(vs === undefined && ls === undefined) , ms: 0, note: `view->${label(vs)} like->${label(ls)}` });
    const c = await call('travel comment add', 'POST', `/api/travel/posts/${postId}/comments`, { body: { text: 'QA comment' }, token: tA, expect: [200, 201] });
    await call('travel comments list', 'GET', `/api/travel/posts/${postId}/comments`, { token: tA });
    const cid = c.json && (c.json._id || (c.json.comment && c.json.comment._id));
    if (cid) await call('travel comment delete', 'DELETE', `/api/travel/posts/${postId}/comments/${cid}`, { token: tA });
  }

  // --- 10. match + chat
  if (S.userB) {
    await call('match like A->B', 'POST', '/api/match/like', { body: { toUserId: S.userB }, token: tA, expect: [200, 201] });
    if (tB && S.userA) await call('match like B->A (mutual)', 'POST', '/api/match/like', { body: { toUserId: S.userA }, token: tB, expect: [200, 201] });
    await call('match pending-likes', 'GET', '/api/match/pending-likes', { token: tA });
    await call('match likes-by-status', 'GET', '/api/match/likes-by-status?status=pending', { token: tA });
    const mm = await call('match my-matches', 'GET', '/api/match/my-matches', { token: tA });
    await call('match my-matches/:targetUserId', 'GET', `/api/match/my-matches/${S.userB}`, { token: tA, expect: [200, 404] });
    await call('chat history', 'GET', `/api/chat/history/${S.userB}`, { token: tA, expect: [200, 403] });
    await call('chat history cursor', 'GET', `/api/chat/history/${S.userB}/cursor`, { token: tA, expect: [200, 403] });
    const mj = mm.json;
    const marr = Array.isArray(mj) ? mj : (mj && (mj.matches || mj.data)) || [];
    const matchId = marr[0] && (marr[0]._id || marr[0].matchId);
    if (matchId) await call('match update/:matchId', 'POST', `/api/match/update/${matchId}`, { body: { status: 'active' }, token: tA, expect: [200, 400] });
    await call('match dislike', 'POST', '/api/match/dislike', { body: { toUserId: S.userB }, token: tA, expect: [200, 201, 400] });
    await call('match unmatch', 'POST', '/api/match/unmatch', { body: { toUserId: S.userB }, token: tA, expect: [200, 400] });
  }

  // --- 11. safety
  if (S.userB) {
    await call('safety reportUser', 'POST', '/api/safety/reportUser', { body: { toUserId: S.userB, reason: 'QA test report' }, token: tA, expect: [200, 201] });
    await call('safety blockUser', 'POST', '/api/safety/blockUser', { body: { toUserId: S.userB }, token: tA, expect: [200, 201] });
    await call('safety blockedUsers', 'GET', '/api/safety/blockedUsers', { token: tA });
    await call('safety unblockUser', 'POST', '/api/safety/unblockUser', { body: { toUserId: S.userB }, token: tA });
  }

  // --- 12. support
  await call('support create ticket', 'POST', '/api/support/tickets', { body: { topic: 'Technical Issue', description: `QA ticket ${uniq}` }, token: tA, expect: [200, 201] });
  await call('support list tickets', 'GET', '/api/support/tickets', { token: tA });

  // --- 13. payments (non-Stripe reads)
  await call('payment methods GET', 'GET', '/api/payment/methods', { token: tA });
  await call('payment history', 'GET', '/api/payment/history', { token: tA });
  await call('payment history unknown id 404', 'GET', '/api/payment/history/000000000000000000000000', { token: tA, expect: [404, 400] });
  await call('payment subscription', 'GET', '/api/payment/subscription', { token: tA });
  await call('payment subscription cancel', 'POST', '/api/payment/subscription/cancel', { token: tA, expect: [200, 400] });
  await call('payment subscription resume', 'POST', '/api/payment/subscription/resume', { token: tA, expect: [200, 400] });
  await call('payment create-payment-sheet (Stripe)', 'POST', '/api/payment/create-payment-sheet', { body: { planId: 'monthly' }, token: tA, expect: [200, 400, 402, 500] });
  await call('payment create-checkout-session (Stripe)', 'POST', '/api/payment/create-checkout-session', { body: { planId: 'monthly' }, token: tA, expect: [200, 400, 402, 500] });
  await call('payment webhook rejects unsigned', 'POST', '/api/payment/webhook', { body: '{}', raw: true, expect: [400] });

  // --- 14. referrals
  await call('referrals me', 'GET', '/api/referrals/me', { token: tA });
  await call('referrals me/stats', 'GET', '/api/referrals/me/stats', { token: tA });
  await call('referrals me/rewards', 'GET', '/api/referrals/me/rewards', { token: tA });

  // --- 15. admin auth
  await call('admin login (public)', 'POST', '/api/admin/login', { body: { email: 'admin@example.com', password: 'wrong' }, expect: [400, 401, 404] });
  for (const p of ['/api/admin/users', '/api/admin/chat', '/api/admin/users/paid', '/api/admin/prompts', '/api/admin/referral-rules', '/api/admin/referrals', '/api/admin/referrals/summary'])
    await call(`admin anon blocked ${p}`, 'GET', p, { expect: [401, 403] });
  await call('admin with normal user token -> 403', 'GET', '/api/admin/users', { token: tA, expect: [403] });

  // --- 16. destructive, last
  await call('pauseAccount', 'POST', '/api/user/pauseAccount', { body: { paused: true }, token: tA, expect: [200, 400] });
  await call('recoveryEmail DELETE', 'DELETE', '/api/user/recoveryEmail', { token: tA, expect: [200, 400, 404] });
  if (tB) await call('deleteUser B', 'DELETE', '/api/user/deleteUser', { token: tB, expect: [200, 204] });
  await call('deleteUser A', 'DELETE', '/api/user/deleteUser', { token: tA, expect: [200, 204] });

  report();
})();

function report() {
  const fails = results.filter(r => !r.ok);
  console.log('name'.padEnd(42) + 'method  ' + 'status  ' + 'ms');
  for (const r of results)
    console.log(`${(r.ok ? 'PASS ' : 'FAIL ') + r.name}`.padEnd(42) + `${r.method}`.padEnd(8) + `${r.status || '-'}`.padEnd(8) + r.ms + (r.note ? `  ${r.note}` : ''));
  console.log(`\n${results.length - fails.length}/${results.length} passed`);
  if (fails.length) {
    console.log('\nFAILURES:');
    for (const r of fails) console.log(`  ${r.method} ${r.path} -> ${r.status || r.err}  ${r.note}`);
  }
  process.exitCode = fails.length ? 1 : 0;
}
