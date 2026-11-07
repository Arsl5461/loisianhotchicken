import { api } from './axios';
import type { ApiSuccess, AuthUser } from '../types';

export type LoginSession = {
  user: AuthUser;
  accessToken: string;
};

export type LoginOtpChallenge = {
  requiresOtp: true;
  challengeId: string;
  email: string;
};

export type LoginResult = LoginSession | LoginOtpChallenge;

export function isLoginOtpChallenge(data: LoginResult): data is LoginOtpChallenge {
  return 'requiresOtp' in data && data.requiresOtp === true;
}

export const authApi = api.injectEndpoints({
  endpoints: (builder) => ({
    login: builder.mutation<ApiSuccess<LoginResult>, { email: string; password: string }>({
      query: (body) => ({ url: '/auth/login', method: 'POST', data: body }),
    }),
    verifyLoginOtp: builder.mutation<
      ApiSuccess<LoginSession>,
      { email: string; challengeId: string; code: string }
    >({
      query: (body) => ({ url: '/auth/verify-otp', method: 'POST', data: body }),
    }),
    resendLoginOtp: builder.mutation<
      ApiSuccess<LoginOtpChallenge>,
      { email: string; challengeId: string }
    >({
      query: (body) => ({ url: '/auth/resend-otp', method: 'POST', data: body }),
    }),
    forgotPassword: builder.mutation<ApiSuccess<Record<string, never>>, { email: string }>({
      query: (body) => ({ url: '/auth/forgot-password', method: 'POST', data: body }),
    }),
    resetPassword: builder.mutation<
      ApiSuccess<Record<string, never>>,
      { email: string; code: string; newPassword: string }
    >({
      query: (body) => ({ url: '/auth/reset-password', method: 'POST', data: body }),
    }),
    changePassword: builder.mutation<
      ApiSuccess<Record<string, never>>,
      { currentPassword: string; newPassword: string }
    >({
      query: (body) => ({ url: '/auth/change-password', method: 'PATCH', data: body }),
    }),
    logout: builder.mutation<ApiSuccess<Record<string, never>>, void>({
      query: () => ({ url: '/auth/logout', method: 'POST' }),
    }),
    me: builder.query<ApiSuccess<AuthUser>, string>({
      query: () => ({ url: '/auth/me' }),
      providesTags: ['Auth'],
    }),
  }),
});

export const {
  useLoginMutation,
  useVerifyLoginOtpMutation,
  useResendLoginOtpMutation,
  useForgotPasswordMutation,
  useResetPasswordMutation,
  useChangePasswordMutation,
  useLogoutMutation,
  useMeQuery,
} = authApi;
