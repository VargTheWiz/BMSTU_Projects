import dayjs from 'dayjs';
import React from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import axiosInstance from '../api';

export const ProductCard = (props) => {
    const { authorized, user } = useSelector((store) => store.user);
    const navigate = useNavigate();
    const handleNavigate = () => {
        navigate(`/product/${props.id_item}`);
    };

    const handleClick = () => {
        const addBasket = async () => {
            let order_date = new Date();
            order_date.setHours(order_date.getHours() - 3);
            const values = {
                status: 'Оформлен',
                item: +props.id_item,
                customer: user.id,
                order_date: dayjs(order_date).format('YYYY-MM-DD HH:mm:ss'),
            };
            await axiosInstance.post('orders/', values);
        };
        addBasket();
    };

    return (
        <div className='p-8 border-b-2 min-w-[400px] max-w-[50vh] flex flex-col cursor-pointer my-8 justify-end'>
            <img
                src={props.photo}
                alt={props.name}
            />
            <p>
                <strong>Название:</strong> {props.name}
            </p>
            <p>
                <strong>Стоимость:</strong> {props.price}
            </p>
            <button onClick={handleNavigate}>Подробнее</button>
            {authorized && (
                <button
                    className='bg-blue-400 text-white w-full rounded-xl mt-2 py-1 '
                    onClick={handleClick}
                >
                    <strong>Добавить в корзину</strong>
                </button>
            )}
        </div>
    );
};
