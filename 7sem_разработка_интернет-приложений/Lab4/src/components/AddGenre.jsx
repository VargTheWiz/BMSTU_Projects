import React, { useState } from 'react';
import axiosInstance from '../api';

export const AddGenre = ({ resetType }) => {
    const [title, setTitle] = useState('');
    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!!title) {
            const values = { title };
            await axiosInstance.post('genres/', values);
            resetType();
        }
    };
    return (
        <form onSubmit={handleSubmit} className='md:w-[600px] flex flex-col gap-1'>
            <p className='font-bold'>Название: </p>
            <input
                className='inline-table md:w-[600px] overflow-y-hidden resize-none border rounded-md px-2 h-7 outline-none'
                value={title}
                onChange={(e) => setTitle(e.target.value)}
            />
            <button type='submit' className='bg-gray-200 px-10 py-1 mt-2 w-full  rounded-md'>
                Добавить
            </button>
        </form>
    );
};
