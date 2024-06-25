import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Navigate, Route, Routes } from 'react-router-dom';
import axiosInstance from './api';
import { Header } from './components/Header';
import { AuthPage } from './pages/AuthPage';
import { HomePage } from './pages/HomePage';
import { ManagerPage } from './pages/ManagerPage';
import { OrdersPage } from './pages/OrdersPage';
import { ProductPage } from './pages/ProductPage';
import { setUser } from './store/reducers/userReducer';

export const App = () => {
    const dispatch = useDispatch();
    const { user, authorized } = useSelector((store) => store.user);
    useEffect(() => {
        const getUser = async () => {
            await axiosInstance.get('api/user').then((response) => dispatch(setUser(response?.data)));
        };
        if (authorized || localStorage.getItem('access')) {
            getUser();
        }
    }, [dispatch, authorized]);
    return (
        <>
            <Header />
            <Routes>
                <Route path='/' element={<HomePage />} />
                {!authorized && <Route path='/auth' element={<AuthPage />} />}
                <Route path='/product/:id' element={<ProductPage />} />
                {authorized && <Route path='/orders' element={<OrdersPage />} />}
                {user?.is_superuser && <Route path='/manager' element={<ManagerPage />} />}
                <Route path='*' element={<Navigate to='/' replace />} />
            </Routes>
        </>
    );
};
