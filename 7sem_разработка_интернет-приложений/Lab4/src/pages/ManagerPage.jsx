import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link } from 'react-router-dom';
import axiosInstance from '../api';
import { AddGenre } from '../components/AddGenre';
import { AddItem } from '../components/AddItem';
import { ManagerItemCard } from '../components/ManagerItemCard';
import { ManagerOrderCard } from '../components/ManagerOrderCard';
import { setOrders } from '../store/reducers/orderReducer';
import { setGenres, setProducts } from '../store/reducers/productReducer';
import { ManagerGenreCard } from '../components/ManagerGenreCard';

export const ManagerPage = () => {
    const dispatch = useDispatch();
    const { products, genres } = useSelector((store) => store.product);
    const { orders } = useSelector((store) => store.order);
    const [type, setType] = useState('');
    const [orderType, setOrderType] = useState('all');
    useEffect(() => {
        const fetchProducts = async () => {
            await axiosInstance.get('items-depth').then((response) => dispatch(setProducts(response?.data)));
        };
        const fetchGenres = async () => {
            await axiosInstance.get('genres').then((response) => dispatch(setGenres(response?.data)));
        };
        const fetchOrders = async () => {
            await axiosInstance.get('orders-depth').then((response) => dispatch(setOrders(response?.data)));
        };
        type === 'Товары' ? fetchProducts() && fetchGenres() : type === 'Заказы' ? fetchOrders() : fetchGenres();
    }, [dispatch, type]);
    return (
        <div className='p-8 flex flex-col gap-4'>
            <div className='flex gap-1'>
                <Link to='/'>Главная</Link> <p>/</p>
                <Link to='#'>Панель менеджера</Link>
            </div>
            <div className='flex md:gap-4 gap-2 flex-wrap'>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'Жанр' && 'bg-gray-200 '}`}
                    onClick={() => setType('Жанр')}
                >
                    Жанр
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'Товары' && 'bg-gray-200 '}`}
                    onClick={() => setType('Товары')}
                >
                    Товары
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'Заказы' && 'bg-gray-200 '}`}
                    onClick={() => setType('Заказы')}
                >
                    Заказы
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'newGenre' && 'bg-gray-200 '}`}
                    onClick={() => setType('newGenre')}
                >
                    Добавить жанр
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'newItem' && 'bg-gray-200 '}`}
                    onClick={() => setType('newItem')}
                >
                    Добавить товар
                </button>
            </div>
            <div>
                {type === 'Жанр' ? (
                    genres.length > 0 &&
                    genres.map((genre) => (
                        <ManagerGenreCard
                            key={genre.id}
                            {...genre}
                        />
                    ))
                ) : type === 'Товары' ? (
                    products?.length > 0 &&
                    products.map((product) => (
                        <ManagerItemCard
                            key={product.id_item}
                            {...product}
                        />
                    ))
                ) : type === 'Заказы' ? (
                    orders.length > 0 && (
                        <div>
                            <div className='flex gap-2 mb-4 flex-wrap'>
                                <button
                                    className={`py-1 px-2 rounded-md border ${orderType === 'all' && 'bg-gray-200 '}`}
                                    onClick={() => setOrderType('all')}
                                >
                                    Все
                                </button>
                                <button
                                    className={`py-1 px-2 rounded-md border ${
                                        orderType === 'Оформлен' && 'bg-gray-200 '
                                    }`}
                                    onClick={() => setOrderType('Оформлен')}
                                >
                                    Оформлен
                                </button>
                                <button
                                    className={`py-1 px-2 rounded-md border ${
                                        orderType === 'В доставке' && 'bg-gray-200 '
                                    }`}
                                    onClick={() => setOrderType('В доставке')}
                                >
                                    В доставке
                                </button>
                                <button
                                    className={`py-1 px-2 rounded-md border ${
                                        orderType === 'Доставлен' && 'bg-gray-200 '
                                    }`}
                                    onClick={() => setOrderType('Доставлен')}
                                >
                                    Доставлен
                                </button>
                                <button
                                    className={`py-1 px-2 rounded-md border ${
                                        orderType === 'Отменен' && 'bg-gray-200 '
                                    }`}
                                    onClick={() => setOrderType('Отменен')}
                                >
                                    Отменен
                                </button>
                            </div>
                            <div className='flex flex-wrap gap-2'>
                                {orders.map((order) =>
                                    orderType === 'all' ? (
                                        <ManagerOrderCard
                                            key={order.id}
                                            {...order}
                                        />
                                    ) : (
                                        orderType === order.status && (
                                            <ManagerOrderCard
                                                key={order.id}
                                                {...order}
                                            />
                                        )
                                    )
                                )}
                            </div>
                        </div>
                    )
                ) : type === 'newItem' ? (
                    <AddItem resetType={() => setType('')} />
                ) : (
                    type === 'newGenre' && <AddGenre resetType={() => setType('')} />
                )}
            </div>
        </div>
    );
};
