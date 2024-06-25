import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import axiosInstance from '../api';
import { setGenres } from '../store/reducers/productReducer';

export const ManagerGenreCard = (props) => {
    const dispatch = useDispatch();
    const [newTitle, setNewTitle] = useState(props.title);

    const handleUpdate = async () => {
        if (!!newTitle) {
            const values = {
                title: newTitle,
            };
            await axiosInstance.put(`genres/${props.id_genre}/`, values).then(async () => {
                await axiosInstance.get('genres/').then((response) => dispatch(setGenres(response?.data)));
            });
        }
    };

    const handleDelete = async () => {
        const values = {
            id: props.id_genre,
            title: props.title,
        };
        await axiosInstance.delete(`genres/${props.id_genre}/`, values).then(async () => {
            await axiosInstance.get('genres').then((response) => dispatch(setGenres(response?.data)));
        });
    };

    return (
        <div className='p-8 border md:w-[560px] flex flex-col justify-center items-center cursor-pointer my-8'>
            <div className='flex flex-col justify-between'>
                <div>
                    <p className='font-bold'>Название: </p>
                    <input
                        className='inline-table w-full overflow-y-hidden resize-none bg-transparent'
                        value={newTitle}
                        onChange={(e) => setNewTitle(e.target.value)}
                    />
                    <button onClick={handleUpdate} className='bg-gray-200 px-10 py-1 mt-2 w-full  rounded-md'>
                        Сохранить
                    </button>
                    <button onClick={handleDelete} className='bg-red-400 text-white px-10 py-1 mt-2 w-full  rounded-md'>
                        Удалить
                    </button>
                </div>
            </div>
        </div>
    );
};
