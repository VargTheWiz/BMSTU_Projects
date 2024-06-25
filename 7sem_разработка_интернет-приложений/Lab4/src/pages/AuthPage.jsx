import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setAuth } from '../store/reducers/userReducer';
import { useNavigate } from 'react-router-dom';
import axiosInstance from '../api';

export const AuthPage = () => {
    const { user } = useSelector((store) => store.user);
    const navigate = useNavigate();
    const dispatch = useDispatch();
    const [type, setType] = useState('signin');
    const [email, setEmail] = useState('');
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const handleType = () => {
        type === 'signin' ? setType('signup') : setType('signin');
        setUsername('');
        setPassword('');
    };
    const handleSubmit = (e) => {
        e.preventDefault();
        if (!!username && !!password) {
            const signIn = async () => {
                const values = { username, password };
                await axiosInstance.post('api/token/obtain', values).then((response) => {
                    dispatch(setAuth(response?.data));
                    navigate('/');
                });
            };
            const signUp = async () => {
                const values = { username, password, email };
                await axiosInstance.post('add_user', values).then((response) => dispatch(setAuth(response?.data)));
                navigate('/');
            };
            type === 'signup' ? signUp() : signIn();
            setPassword('');
        }
    };

    useEffect(() => {
        !!user && user.username && navigate('/');
    }, [navigate, user, user?.username]);

    return (
        <div className='flex justify-center items-center'>
            <form className='flex flex-col w-80 gap-4' onSubmit={handleSubmit}>
                {type === 'signup' && (
                    <div className='flex flex-col'>
                        <label htmlFor='email'>Email</label>
                        <input
                            id='email'
                            className='border h-10 py-2 px-4 outline-none rounded-md'
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            placeholder='Email...'
                        />
                    </div>
                )}
                <div className='flex flex-col'>
                    <label htmlFor='username'>Имя пользователя</label>
                    <input
                        id='username'
                        className='border h-10 py-2 px-4 outline-none rounded-md'
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                        placeholder='Имя пользователя...'
                    />
                </div>
                <div className='flex flex-col'>
                    <label htmlFor='password'>Пароль</label>
                    <input
                        id='password'
                        className='border h-10 py-2 px-4 outline-none rounded-md'
                        type='password'
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        placeholder='Пароль...'
                    />
                </div>
                <button className='h-10 py-2 px-6 rounded-md bg-blue-500 text-white  outline-none' type='submit'>
                    {type === 'signin' ? 'Войти' : 'Зарегистрироваться'}
                </button>
                <button className='self-center underline' onClick={handleType}>
                    {type === 'signin' ? 'Зарегистрироваться' : 'Войти'}
                </button>
            </form>
        </div>
    );
};
