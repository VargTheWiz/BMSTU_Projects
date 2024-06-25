import { createSlice } from '@reduxjs/toolkit';

const initialState = {
    genres: [],
    genre: {},
    products: [],
    product: {},
};

const productSlice = createSlice({
    name: 'product',
    initialState,
    reducers: {
        setGenres: (state, { payload }) => {
            state.genres = payload;
        },
        setGenre: (state, { payload }) => {
            state.genre = payload;
        },
        setProducts: (state, { payload }) => {
            if (!!payload?.id) {
                state.products = payload.products.filter((product) => +product.genre.id_genre === +payload.id);
            } else if (!payload.products) {
                state.products = payload;
            } else {
                state.products = payload.products;
            }
        },
        setProduct: (state, { payload }) => {
            state.product = payload;
        },
        resetGenre: (state) => {
            state.genre = {};
        },
    },
});

export const productReducer = productSlice.reducer;

export const { setGenre, setGenres, setProduct, setProducts, resetGenre } = productSlice.actions;
