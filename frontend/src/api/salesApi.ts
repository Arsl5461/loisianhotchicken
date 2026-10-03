import { api } from './axios';
import type { ApiSuccess } from '../types';

const resourceApi = (name: string, tag: 'Sale' | 'Expense' | 'User') => ({
  list: (builder: any) =>
    builder.query({
      query: (params: Record<string, unknown>) => ({ url: `/${name}`, params }),
      providesTags: [tag],
    }),
  create: (builder: any) =>
    builder.mutation({
      query: (data: Record<string, unknown>) => ({ url: `/${name}`, method: 'POST', data }),
      invalidatesTags: [tag, 'Dashboard', 'Report'],
    }),
  update: (builder: any) =>
    builder.mutation({
      query: ({ id, data }: { id: string; data: Record<string, unknown> }) => ({
        url: `/${name}/${id}`,
        method: 'PATCH',
        data,
      }),
      invalidatesTags: [tag, 'Dashboard', 'Report'],
    }),
  remove: (builder: any) =>
    builder.mutation({
      query: (id: string) => ({ url: `/${name}/${id}`, method: 'DELETE' }),
      invalidatesTags: [tag, 'Dashboard', 'Report'],
    }),
  bulkRemove: (builder: any) =>
    builder.mutation({
      query: (ids: string[]) => ({ url: `/${name}/bulk-delete`, method: 'POST', data: { ids } }),
      invalidatesTags: [tag, 'Dashboard', 'Report'],
    }),
});

export const salesApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getSales: resourceApi('sales', 'Sale').list(builder),
    createSale: resourceApi('sales', 'Sale').create(builder),
    updateSale: resourceApi('sales', 'Sale').update(builder),
    deleteSale: resourceApi('sales', 'Sale').remove(builder),
    bulkDeleteSales: resourceApi('sales', 'Sale').bulkRemove(builder),
    getSaleCategories: builder.query({
      query: (params: Record<string, unknown> = {}) => ({ url: '/sale-categories', params }),
      providesTags: ['SaleCategory'],
    }),
    createSaleCategory: builder.mutation({
      query: (data: Record<string, unknown>) => ({ url: '/sale-categories', method: 'POST', data }),
      invalidatesTags: ['SaleCategory'],
    }),
    updateSaleCategory: builder.mutation({
      query: ({ id, data }: { id: string; data: Record<string, unknown> }) => ({
        url: `/sale-categories/${id}`,
        method: 'PATCH',
        data,
      }),
      invalidatesTags: ['SaleCategory'],
    }),
    deleteSaleCategory: builder.mutation({
      query: (id: string) => ({ url: `/sale-categories/${id}`, method: 'DELETE' }),
      invalidatesTags: ['SaleCategory'],
    }),
    bulkDeleteSaleCategories: builder.mutation({
      query: (ids: string[]) => ({ url: '/sale-categories/bulk-delete', method: 'POST', data: { ids } }),
      invalidatesTags: ['SaleCategory'],
    }),
  }),
});

export const {
  useGetSalesQuery,
  useCreateSaleMutation,
  useUpdateSaleMutation,
  useDeleteSaleMutation,
  useBulkDeleteSalesMutation,
  useGetSaleCategoriesQuery,
  useCreateSaleCategoryMutation,
  useUpdateSaleCategoryMutation,
  useDeleteSaleCategoryMutation,
  useBulkDeleteSaleCategoriesMutation,
} = salesApi;
