import dayjs from 'dayjs';
import React from 'react';
import { useDispatch } from 'react-redux';
import axiosInstance from '../api';
import { setOrders } from '../store/reducers/orderReducer';

export const ManagerOrderCard = (props) => {
    const dispatch = useDispatch();
    const handleUpdate = async (status) => {
        const newDate = new Date();
        newDate.setHours(newDate.getHours() - 3);
        const values = { status, newDate: dayjs(newDate).format('YYYY-MM-DD HH:mm:ss') };
        await axiosInstance.put(`orders/${props.id}/`, values).then(async () => {
            await axiosInstance.get('orders-depth').then((response) => dispatch(setOrders(response?.data)));
        });
    };
    return (
        <div className='p-8 md:w-[720px] border rounded-md flex flex-col md:flex-row gap-8 items-start'>
            <img
                src={props?.item.photo}
                alt={props?.item.name}
                className='w-96'
            />
            <div>
                <p>Название: {props?.item.name}</p>
                <p>Стоимость: {props?.item.price}</p>
                <p>Пользователь: {props?.customer?.email}</p>
                <p>Дата добавления: {dayjs(props.order_date).format('YYYY.MM.DD HH:mm')}</p>
                {props?.newDate && <p>Дата обновления: {dayjs(props.newDate).format('YYYY.MM.DD HH:mm')}</p>}
                <select onChange={(e) => handleUpdate(e.target.value)}>
                    <option disabled>Статус заказа</option>
                    {props.status === 'Оформлен' && (
                        <>
                            <option
                                selected={props.status === 'Оформлен'}
                                value='Оформлен'
                            >
                                Оформлен
                            </option>
                            <option
                                selected={props.status === 'В доставке'}
                                value='В доставке'
                            >
                                В доставке
                            </option>
                        </>
                    )}
                    {props.status === 'В доставке' && (
                        <>
                            <option
                                selected={props.status === 'В доставке'}
                                value='В доставке'
                            >
                                В доставке
                            </option>
                            <option
                                selected={props.status === 'Доставлен'}
                                value='Доставлен'
                            >
                                Доставлен
                            </option>
                        </>
                    )}
                    {props.status === 'Доставлен' && (
                        <option
                            selected={props.status === 'Доставлен'}
                            value='Доставлен'
                        >
                            Доставлен
                        </option>
                    )}
                    {props.status === 'Отменен' && (
                        <option
                            selected={props.status === 'Доставлен'}
                            value='Доставлен'
                        >
                            Отменен
                        </option>
                    )}
                </select>
            </div>
        </div>
    );
};
