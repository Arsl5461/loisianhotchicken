import { api } from './axios';

export const expensesApi = api.injectEndpoints({
  endpoints: (builder) => ({
    getExpenses: builder.query({
      query: (params: Record<string, unknown>) => ({ url: '/expenses', params }),
      providesTags: ['Expense'],
    }),
    createExpense: builder.mutation({
      query: (data: Record<string, unknown>) => ({ url: '/expenses', method: 'POST', data }),
      invalidatesTags: ['Expense', 'Dashboard', 'Report'],
    }),
    updateExpense: builder.mutation({
      query: ({ id, data }: { id: string; data: Record<string, unknown> }) => ({
        url: `/expenses/${id}`,
        method: 'PATCH',
        data,
      }),
      invalidatesTags: ['Expense', 'Dashboard', 'Report'],
    }),
    deleteExpense: builder.mutation({
      query: (id: string) => ({ url: `/expenses/${id}`, method: 'DELETE' }),
      invalidatesTags: ['Expense', 'Dashboard', 'Report'],
    }),
    bulkDeleteExpenses: builder.mutation({
      query: (ids: string[]) => ({ url: '/expenses/bulk-delete', method: 'POST', data: { ids } }),
      invalidatesTags: ['Expense', 'Dashboard', 'Report'],
    }),
  }),
});

export const {
  useGetExpensesQuery,
  useCreateExpenseMutation,
  useUpdateExpenseMutation,
  useDeleteExpenseMutation,
  useBulkDeleteExpensesMutation,
} = expensesApi;
