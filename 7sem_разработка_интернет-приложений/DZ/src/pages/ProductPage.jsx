import dayjs from 'dayjs';
import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { axiosInstance } from '../api';
import { setProduct } from '../store/reducers/productReducer';

export const ProductPage = () => {
    const dispatch = useDispatch();
    const { product } = useSelector((store) => store.product);
    const { id } = useParams();
    const { authorized, user } = useSelector((store) => store.user);
    const navigate = useNavigate();

    const handleClick = () => {
        const addBasket = async () => {
            let order_date = new Date();
            order_date.setHours(order_date.getHours() - 3);
            const values = {
                status: 'Оформлен',
                item: +id,
                customer: user.id,
                order_date: dayjs(order_date).format('YYYY-MM-DD HH:mm:ss'),
            };
            await axiosInstance.post('orders/', values);
        };
        addBasket();
    };

    useEffect(() => {
        const fetchProduct = async () => {
            await axiosInstance.get(`/items-depth/${id}`).then((response) => dispatch(setProduct(response?.data)));
        };

        fetchProduct();
    }, [dispatch, id, navigate]);
    return (
        <div className='m-8'>
            <div className='flex gap-1'>
                <Link to='/'>{product?.genre?.title ? product?.genre?.title : 'Главная'}</Link> <p>/</p>
                <Link to='#'>{product.name}</Link>
            </div>
            {!!product && (
                <div className='p-8 rounded-xlmin-w-[400px] max-w-[50vh] flex flex-col justify-center items-start cursor-pointer mt-8'>
                    <img
                        src={product.photo}
                        alt={product.name}
                    />
                    <p>
                        <strong>Название:</strong> {product.name}
                    </p>
                    <p>
                        <strong>Жанр:</strong> {product.genre?.title}
                    </p>
                    <p>
                        <strong>Автор:</strong> {product.author}
                    </p>
                    <p>
                        <strong>Описание:</strong> {product.description}
                    </p>
                    <p>
                        <strong>Стоимость:</strong> {product.price}
                    </p>
                    {authorized && (
                        <button
                            className='bg-blue-400 text-white w-full rounded-xl mt-2 py-1 '
                            onClick={handleClick}
                        >
                            <strong>Добавить в корзину</strong>
                        </button>
                    )}
                </div>
            )}
        </div>
    );
};
