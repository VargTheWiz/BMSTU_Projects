import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import axiosInstance from '../api';

export const AddItem = ({ resetType }) => {
    const { genres } = useSelector((store) => store.product);
    const [name, setName] = useState('');
    const [description, setDescription] = useState('');
    const [genre, setGenre] = useState('');
    const [price, setPrice] = useState('');
    const [author, setAuthor] = useState('');
    const [image, setImage] = useState();
    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!!name && !!author && !!genre && !!description && !!price && image) {
            const formData = new FormData();
            formData.append('name', name);
            formData.append('description', description);
            formData.append('author', author);
            formData.append('genre', genre);
            formData.append('price', price);
            formData.append('photo', image[0]);
            await axiosInstance.post('items/', formData);
            resetType();
        }
    };
    return (
        <form
            onSubmit={handleSubmit}
            className='md:w-[600px] flex flex-col gap-1'
        >
            <p className='font-bold'>Название: </p>
            <input
                className='inline-table md:w-[600px] overflow-y-hidden resize-none border rounded-md px-2 h-7 outline-none'
                value={name}
                onChange={(e) => setName(e.target.value)}
            />
            <p className='font-bold'>Описание: </p>
            <input
                className='inline-table md:w-[600px] overflow-y-hidden resize-none border rounded-md px-2 h-7 outline-none'
                value={description}
                onChange={(e) => setDescription(e.target.value)}
            />
            <p className='font-bold'>Автор: </p>
            <input
                className='inline-table md:w-[600px] overflow-y-hidden resize-none border rounded-md px-2 h-7 outline-none'
                value={author}
                onChange={(e) => setAuthor(e.target.value)}
            />
            <p className='font-bold'>Жанр: </p>
            <select
                className='h-7 rounded-md'
                onChange={(e) => setGenre(e.target.value)}
            >
                <option disabled>Жанр</option>
                {genres.length > 0 && genres.map((genre) => <option value={genre.id_genre}>{genre.title}</option>)}
            </select>
            <p className='font-bold'>Стоимость: </p>
            <input
                type='number'
                className='inline-table md:w-[600px] overflow-y-hidden resize-none border rounded-md px-2 h-7 outline-none'
                value={price}
                onChange={(e) => setPrice(e.target.value)}
            />
            <input
                type='file'
                accept='image/png, image/gif, image/jpeg'
                onChange={(e) => setImage(e.target.files)}
            />
            <button
                type='submit'
                className='bg-gray-200 px-10 py-1 mt-2 w-full  rounded-md'
            >
                Добавить
            </button>
        </form>
    );
};
