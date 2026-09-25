import { api } from './axios';

export const borrowingsApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getBorrowings: builder.query({
      query: (params: Record<string, unknown>) => ({ url: '/borrowings', params }),
      providesTags: ['Borrowing'],
    }),
    createBorrowing: builder.mutation({
      query: (data: Record<string, unknown>) => ({ url: '/borrowings', method: 'POST', data }),
      invalidatesTags: ['Borrowing', 'Dashboard', 'Report'],
    }),
    updateBorrowing: builder.mutation({
      query: ({ id, data }: { id: string; data: Record<string, unknown> }) => ({
        url: `/borrowings/${id}`,
        method: 'PATCH',
        data,
      }),
      invalidatesTags: ['Borrowing', 'Dashboard', 'Report'],
    }),
    repayBorrowing: builder.mutation({
      query: ({ id, data }: { id: string; data: Record<string, unknown> }) => ({
        url: `/borrowings/${id}/repay`,
        method: 'POST',
        data,
      }),
      invalidatesTags: ['Borrowing', 'Dashboard', 'Report'],
    }),
    deleteBorrowing: builder.mutation({
      query: (id: string) => ({ url: `/borrowings/${id}`, method: 'DELETE' }),
      invalidatesTags: ['Borrowing', 'Dashboard', 'Report'],
    }),
    bulkDeleteBorrowings: builder.mutation({
      query: (ids: string[]) => ({ url: '/borrowings/bulk-delete', method: 'POST', data: { ids } }),
      invalidatesTags: ['Borrowing', 'Dashboard', 'Report'],
    }),
  }),
});

export const {
  useGetBorrowingsQuery,
  useCreateBorrowingMutation,
  useUpdateBorrowingMutation,
  useRepayBorrowingMutation,
  useDeleteBorrowingMutation,
  useBulkDeleteBorrowingsMutation,
} = borrowingsApi;
