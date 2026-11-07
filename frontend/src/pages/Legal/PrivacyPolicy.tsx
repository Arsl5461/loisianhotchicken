import { Link } from 'react-router-dom';
import logo from '../../assets/logos/louisiana-hot-chicken.jpg';

const LAST_UPDATED = 'November 7, 2026';
const CONTACT_EMAIL = 'admin@louisianahotchicken.com';
const WEBSITE = 'https://lhc-holdings.com';
const APP_NAME = 'LHC (Louisiana Hot Chicken)';

export default function PrivacyPolicy() {
  return (
    <div className="min-h-screen bg-[#F8F9FA] text-slate-800">
      <header className="border-b border-slate-200 bg-white">
        <div className="mx-auto flex max-w-3xl items-center justify-between gap-4 px-6 py-5">
          <div className="flex items-center gap-3">
            <img src={logo} alt="Louisiana Hot Chicken" className="h-11 w-11 rounded-2xl object-cover" />
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.18em] text-brand-red">Louisiana Hot Chicken</p>
              <p className="text-sm font-semibold text-slate-900">Privacy Policy</p>
            </div>
          </div>
          <Link to="/login" className="text-sm font-semibold text-brand-red hover:underline">
            Sign in
          </Link>
        </div>
      </header>

      <main className="mx-auto max-w-3xl px-6 py-10">
        <div className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm sm:p-10">
          <p className="text-xs font-bold uppercase tracking-[0.2em] text-brand-red">Legal</p>
          <h1 className="mt-2 text-3xl font-extrabold tracking-tight text-slate-900">Privacy Policy</h1>
          <p className="mt-2 text-sm text-slate-500">Last updated: {LAST_UPDATED}</p>

          <div className="prose-legal mt-8 space-y-8 text-[15px] leading-7 text-slate-700">
            <section>
              <h2>1. Introduction</h2>
              <p>
                This Privacy Policy describes how {APP_NAME} (“we”, “us”, or “our”) collects, uses, stores, and
                shares information when you use our website, web dashboard, and mobile applications for Android and
                iOS (together, the “Services”).
              </p>
              <p>
                {APP_NAME} is an internal business operations tool for authorized Louisiana Hot Chicken team members.
                It is not a consumer ordering app and is not directed to children.
              </p>
            </section>

            <section>
              <h2>2. Who this policy covers</h2>
              <p>This policy applies to:</p>
              <ul>
                <li>Authorized users of the LHC web admin dashboard</li>
                <li>Authorized users of the LHC Android and iOS apps</li>
                <li>Visitors who open this privacy policy page</li>
              </ul>
            </section>

            <section>
              <h2>3. Information we collect</h2>
              <h3>Account and profile information</h3>
              <ul>
                <li>Name</li>
                <li>Email address</li>
                <li>Password (stored only in hashed form)</li>
                <li>Role, permissions, and assigned stores</li>
                <li>Optional organization profile details such as phone number and address</li>
              </ul>

              <h3>Authentication and security data</h3>
              <ul>
                <li>Sign-in credentials and one-time verification codes sent by email</li>
                <li>Access and refresh tokens used to keep you signed in</li>
                <li>Password reset codes</li>
                <li>Basic login activity needed to protect accounts</li>
              </ul>

              <h3>Business and operational data you enter</h3>
              <ul>
                <li>Store information</li>
                <li>Sales and sale categories</li>
                <li>Expenses, receipts, and payment methods</li>
                <li>Borrowings and repayments</li>
                <li>Reports and related financial summaries</li>
              </ul>

              <h3>Device and technical information</h3>
              <ul>
                <li>IP address and approximate request metadata</li>
                <li>Browser or app type, device type, and operating system</li>
                <li>App version and basic diagnostic/error logs</li>
                <li>Network connection details required to communicate with our servers</li>
              </ul>

              <h3>Media you choose to upload</h3>
              <ul>
                <li>Photos, images, or files attached as expense receipts or sales attachments</li>
                <li>Camera or photo-library access is used only when you choose to attach a file</li>
              </ul>
            </section>

            <section>
              <h2>4. How we use information</h2>
              <p>We use the information above to:</p>
              <ul>
                <li>Authenticate users and manage secure sessions</li>
                <li>Provide multi-store operations features such as sales, expenses, borrowings, and reporting</li>
                <li>Enforce role-based access and store-level permissions</li>
                <li>Send sign-in and password-reset codes by email</li>
                <li>Maintain security, prevent abuse, and troubleshoot issues</li>
                <li>Improve reliability and support of the Services</li>
                <li>Comply with legal obligations that apply to our business</li>
              </ul>
              <p>We do not use your data for advertising or personalized ads.</p>
            </section>

            <section>
              <h2>5. How we share information</h2>
              <p>We do not sell personal information.</p>
              <p>We may share information only with:</p>
              <ul>
                <li>
                  <strong>Service providers</strong> that help us host, store, secure, or operate the Services (for
                  example cloud hosting, email delivery, and infrastructure providers), under agreements that limit
                  their use of the data
                </li>
                <li>
                  <strong>Authorized organization administrators</strong> within Louisiana Hot Chicken who manage
                  users, stores, and operations data
                </li>
                <li>
                  <strong>Legal authorities</strong> when required by law, court order, or to protect rights, safety,
                  and security
                </li>
              </ul>
            </section>

            <section>
              <h2>6. Data storage and security</h2>
              <p>
                We store account and operational data on our servers and related infrastructure. We use industry
                standard protections such as HTTPS encryption in transit, hashed passwords, authenticated API access,
                and role-based permissions.
              </p>
              <p>
                No method of transmission or storage is 100% secure. We work to protect your information, but we
                cannot guarantee absolute security.
              </p>
            </section>

            <section>
              <h2>7. Data retention</h2>
              <p>
                We retain account and business records for as long as needed to operate the Services, meet business
                and accounting needs, resolve disputes, and comply with legal requirements. When an account is
                deactivated or deletion is requested, we will remove or anonymize personal account data where
                reasonably possible, subject to records we must keep for legitimate business or legal reasons.
              </p>
            </section>

            <section>
              <h2>8. Your choices and rights</h2>
              <p>Depending on your role and applicable law, you may be able to:</p>
              <ul>
                <li>Access or update profile and organization information in Settings</li>
                <li>Request that an administrator update or deactivate your account</li>
                <li>Request deletion of personal account data by contacting us</li>
                <li>Sign out to clear local session tokens on your device</li>
              </ul>
              <p>
                To request access, correction, or deletion, email{' '}
                <a href={`mailto:${CONTACT_EMAIL}`}>{CONTACT_EMAIL}</a>.
              </p>
            </section>

            <section>
              <h2>9. Children’s privacy</h2>
              <p>
                The Services are intended for authorized adult business users. We do not knowingly collect personal
                information from children. If you believe a child has provided personal information, contact us and we
                will take appropriate steps to delete it.
              </p>
            </section>

            <section>
              <h2>10. International access</h2>
              <p>
                The Services may be accessed from different locations. If you use the Services from outside the
                country where our servers are located, your information may be processed in jurisdictions with
                different data-protection laws.
              </p>
            </section>

            <section>
              <h2>11. Third-party links and services</h2>
              <p>
                The Services may interact with infrastructure providers needed to run hosting, email, and file
                storage. Those providers process data only as needed to deliver their services to us. This policy does
                not cover unrelated third-party websites you may visit outside the Services.
              </p>
            </section>

            <section>
              <h2>12. Changes to this policy</h2>
              <p>
                We may update this Privacy Policy from time to time. When we do, we will revise the “Last updated”
                date on this page. Continued use of the Services after changes means you acknowledge the updated
                policy.
              </p>
            </section>

            <section>
              <h2>13. Contact us</h2>
              <p>If you have questions about this Privacy Policy or our data practices, contact:</p>
              <ul>
                <li>
                  Email: <a href={`mailto:${CONTACT_EMAIL}`}>{CONTACT_EMAIL}</a>
                </li>
                <li>
                  Website: <a href={WEBSITE}>{WEBSITE}</a>
                </li>
                <li>Organization: Louisiana Hot Chicken / LHC Holdings</li>
              </ul>
            </section>
          </div>
        </div>

        <p className="mt-6 text-center text-xs text-slate-500">
          © {new Date().getFullYear()} Louisiana Hot Chicken. All rights reserved.
        </p>
      </main>

      <style>{`
        .prose-legal h2 {
          margin-bottom: 0.75rem;
          font-size: 1.125rem;
          font-weight: 800;
          color: #0f172a;
        }
        .prose-legal h3 {
          margin: 1rem 0 0.5rem;
          font-size: 0.95rem;
          font-weight: 700;
          color: #1e293b;
        }
        .prose-legal p,
        .prose-legal ul {
          margin-top: 0.5rem;
        }
        .prose-legal ul {
          list-style: disc;
          padding-left: 1.25rem;
        }
        .prose-legal a {
          color: #a6190f;
          font-weight: 600;
          text-decoration: underline;
        }
      `}</style>
    </div>
  );
}
