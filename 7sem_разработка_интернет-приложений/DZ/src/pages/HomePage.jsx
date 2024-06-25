import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link } from 'react-router-dom';
import { axiosInstance } from '../api';
import { ProductCard } from '../components/ProductCard';
import {resetGenre, setGenre, setGenres, setProducts } from '../store/reducers/productReducer';

export const HomePage = () => {
    const { genres, genre: selectedGenre, products } = useSelector((store) => store.product);
    const dispatch = useDispatch();
    const [q, setQ] = useState('');
    const [min, setMin] = useState('');
    const [max, setMax] = useState('');
    const [value, setValue] = useState({});

    useEffect(() => {
        const fetchGenres = async () => {
            await axiosInstance.get('genres').then((response) => dispatch(setGenres(response?.data)));
        };

        const fetchProducts = async (id) => {
            await axiosInstance
                .get('items-depth', { params: value })
                .then((response) => dispatch(setProducts({ products: response?.data, id })));
        };

        fetchGenres();
        fetchProducts(selectedGenre.id_genre);
    }, [dispatch, selectedGenre, value]);

    const handleReset = () => {
        setQ('');
        setMax('');
        setMin('');
        setValue('');
    };

    const handleGenre = async (id) => {
        setQ('');
        setMin('');
        setMax('');
        setValue('');
        if (id === selectedGenre.id_genre) {
            dispatch(resetGenre());
        } else {
            await axiosInstance.get(`genres/${id}`).then((response) => dispatch(setGenre(response?.data)));
        }
    };

    return (
        <div className='m-8'>
            <div className='flex gap-1'>
                <Link to='#'>{selectedGenre.title ? selectedGenre.title : 'Главная'}</Link> <p>/</p>
            </div>
            <div className='flex gap-2 my-8 flex-wrap'>
                {genres.map((genre) => (
                    <button
                        key={genre.id_genre}
                        className={`md:py-4 md:px-8 py-1 px-2 border rounded-xl ${
                            genre.title === selectedGenre.title && 'bg-gray-200'
                        }`}
                        onClick={() => handleGenre(genre.id_genre)}
                    >
                        {genre.title}
                    </button>
                ))}
            </div>
            <div>
                <div>
                    <p>Название</p>
                    <input
                        value={q}
                        onChange={(e) => setQ(e.target.value)}
                        placeholder='Введите значение...'
                        className='py-1 px-3 w-80 rounded-lg bg-gray-200 outline-none'
                    />
                </div>
                <div>
                    <p>Минимальная стоимость</p>
                    <input
                        value={min}
                        onChange={(e) => setMin(e.target.value)}
                        placeholder='Введите значение...'
                        type='number'
                        className='py-1 px-3 w-80 rounded-lg bg-gray-200 outline-none'
                    />
                </div>
                <div>
                    <p>Максимальная стоимость</p>
                    <input
                        value={max}
                        onChange={(e) => setMax(e.target.value)}
                        placeholder='Введите значение...'
                        type='number'
                        className='py-1 px-3 w-80 rounded-lg bg-gray-200 outline-none'
                    />
                </div>
                <div className='mt-2 flex gap-2'>
                    <button
                        onClick={() => setValue({ q, min_cost: min, max_cost: max })}
                        className='py-1 px-4 bg-gray-200 rounded-xl'
                    >
                        Искать
                    </button>
                    <button onClick={handleReset} className='py-1 px-4 bg-gray-200 rounded-xl'>
                        Сбросить
                    </button>
                </div>
            </div>
            {products.length > 0 && (
                <div className='flex flex-wrap gap-4'>
                    {products.map((product) => (
                        <ProductCard key={product.id_item} {...product} />
                    ))}
                </div>
            )}
        </div>
    );
};
