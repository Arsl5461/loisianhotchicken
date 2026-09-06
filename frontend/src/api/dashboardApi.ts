import { api } from './axios';
import type { ApiSuccess, DashboardOverview } from '../types';

export const dashboardApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getOverview: builder.query<ApiSuccess<DashboardOverview>, { range?: string; storeId?: string; groupBy?: string }>({
      query: (params) => ({ url: '/dashboard/overview', params }),
      providesTags: ['Dashboard'],
    }),
    getProfitLoss: builder.query<ApiSuccess<unknown>, Record<string, unknown> | void>({
      query: (params) => ({ url: '/reports/profit-loss', params: params || {} }),
      providesTags: ['Report'],
    }),
    getStoreComparison: builder.query<ApiSuccess<unknown>, Record<string, unknown> | void>({
      query: (params) => ({ url: '/reports/store-comparison', params: params || {} }),
      providesTags: ['Report'],
    }),
  }),
});

export const { useGetOverviewQuery, useGetProfitLossQuery, useGetStoreComparisonQuery } = dashboardApi;
