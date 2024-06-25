import { createSlice } from '@reduxjs/toolkit';

const initialState = { authorized: false, user: {} };

const userSlice = createSlice({
    name: 'user',
    initialState,
    reducers: {
        setAuth: (state, { payload }) => {
            state.authorized = true;
            localStorage.setItem('access', payload?.access);
            localStorage.setItem('refresh', payload?.refresh);
        },
        setUser: (state, { payload }) => {
            state.user = payload.data;
            state.authorized = true;
        },
        logout: (state) => {
            state.authorized = false;
            state.user = {};
            localStorage.removeItem('access');
            localStorage.removeItem('refresh');
        },
    },
});

export const userReducer = userSlice.reducer;
export const { setAuth, setUser, logout } = userSlice.actions;
