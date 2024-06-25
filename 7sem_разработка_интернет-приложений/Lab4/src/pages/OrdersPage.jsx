import dayjs from 'dayjs';
import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link, useNavigate } from 'react-router-dom';
import axiosInstance from '../api';
import { setOrders } from '../store/reducers/orderReducer';

export const OrdersPage = () => {
    const { orders } = useSelector((store) => store.order);
    const { authorized, user } = useSelector((store) => store.user);
    const navigate = useNavigate();
    const [type, setType] = useState('all');
    const dispatch = useDispatch();
    useEffect(() => {
        const fetchBasket = async () => {
            const values = { id: user.id };
            await axiosInstance
                .get('orders-depth/', { params: values })
                .then((response) => dispatch(setOrders(response?.data)));
        };
        authorized ? fetchBasket() : navigate('/');
    }, [authorized, dispatch, navigate, user?.id]);

    const handleDelete = (id) => {
        const fetchDelete = async (id) => {
            const newDate = new Date();
            newDate.setHours(newDate.getHours() - 3);
            const values = { status: 'Отменен', newDate: dayjs(newDate).format('YYYY-MM-DD HH:mm:ss') };
            const userId = { id: user.id };
            await axiosInstance.put(`orders/${id}/`, values).then(async () => {
                await axiosInstance
                    .get('orders-depth', { params: userId })
                    .then((response) => dispatch(setOrders(response?.data)));
            });
        };
        fetchDelete(id);
    };

    return (
        <div className='m-8'>
            <div className='flex gap-1'>
                <Link to='/'>Главная</Link> <p>/</p>
                <Link to='#'>Заказы</Link>
            </div>
            <div className='flex gap-2 flex-wrap'>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'all' && 'bg-gray-200'}`}
                    onClick={() => setType('all')}
                >
                    Все
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'Оформлен' && 'bg-gray-200'}`}
                    onClick={() => setType('Оформлен')}
                >
                    Оформлен
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'В доставке' && 'bg-gray-200'}`}
                    onClick={() => setType('В доставке')}
                >
                    В доставке
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'Доставлен' && 'bg-gray-200'}`}
                    onClick={() => setType('Доставлен')}
                >
                    Доставлен
                </button>
                <button
                    className={`py-1 px-2 rounded-md border ${type === 'Отменен' && 'bg-gray-200'}`}
                    onClick={() => setType('Отменен')}
                >
                    Отменен
                </button>
            </div>
            <ul className='flex mt-8 flex-wrap gap-4'>
                {orders.map((order) =>
                    !!order?.item && type === 'all' ? (
                        <li
                            key={order.id}
                            className='p-8 border rounded-md w-[440px]'
                        >
                            <img
                                src={order?.item.photo}
                                alt={order?.item.name}
                                className='w-96'
                            />
                            <p>Название: {order?.item.name}</p>
                            <p>Стоимость: {order?.item.price}</p>
                            <p>Дата добавления: {dayjs(order.order_date).format('YYYY.MM.DD HH:mm')}</p>
                            {order.newDate && <p>Дата обновления: {dayjs(order.newDate).format('YYYY.MM.DD HH:mm')}</p>}
                            <p>Статус: {order.status}</p>
                            {order.status !== 'Доставлен' && order.status !== 'Отменен' && (
                                <button
                                    onClick={() => handleDelete(order.id)}
                                    className='bg-red-400 text-white  w-full rounded-md'
                                >
                                    Отменить
                                </button>
                            )}
                        </li>
                    ) : (
                        order.status === type && (
                            <li
                                key={order.id}
                                className='p-8 border rounded-md w-[440px]'
                            >
                                <img
                                    src={order?.item.photo}
                                    alt={order?.item.name}
                                    className='w-96'
                                />
                                <p>Название: {order?.item.name}</p>
                                <p>Стоимость: {order?.item.price}</p>
                                <p>Дата добавления: {dayjs(order.order_date).format('YYYY.MM.DD HH:mm')}</p>
                                <p>Статус: {order.status}</p>
                                {order.status !== 'Доставлен' && order.status !== 'Отменен' && (
                                    <button
                                        onClick={() => handleDelete(order.id)}
                                        className='bg-red-400 text-white  w-full rounded-md'
                                    >
                                        Отменить
                                    </button>
                                )}
                            </li>
                        )
                    )
                )}
            </ul>
        </div>
    );
};
