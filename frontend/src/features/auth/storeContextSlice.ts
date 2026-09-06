import { createSlice, type PayloadAction } from '@reduxjs/toolkit';

interface StoreContextState {
  selectedStoreId: string | null;
}

const storeContextSlice = createSlice({
  name: 'storeContext',
  initialState: {
    selectedStoreId: localStorage.getItem('lhc_store_id'),
  } as StoreContextState,
  reducers: {
    setSelectedStore: (state, action: PayloadAction<string | null>) => {
      state.selectedStoreId = action.payload;
      if (action.payload) {
        localStorage.setItem('lhc_store_id', action.payload);
      } else {
        localStorage.removeItem('lhc_store_id');
      }
    },
  },
});

export const { setSelectedStore } = storeContextSlice.actions;
export default storeContextSlice.reducer;
