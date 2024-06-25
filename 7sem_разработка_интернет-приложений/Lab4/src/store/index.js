import { configureStore } from '@reduxjs/toolkit';
import { orderReducer } from './reducers/orderReducer';
import { productReducer } from './reducers/productReducer';
import { userReducer } from './reducers/userReducer';

export const store = configureStore({ reducer: { product: productReducer, user: userReducer, order: orderReducer } });
