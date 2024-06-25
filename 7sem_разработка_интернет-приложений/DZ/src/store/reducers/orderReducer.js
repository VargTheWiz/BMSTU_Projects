import { createSlice } from '@reduxjs/toolkit';

const initialState = { orders: [] };

const orderSlice = createSlice({
    name: 'order',
    initialState,
    reducers: {
        setOrders: (state, { payload }) => {
            state.orders = payload;
        },
    },
});

export const orderReducer = orderSlice.reducer;

export const { setOrders } = orderSlice.actions;
