import axios from 'axios';

export const axiosInstance = axios.create({ baseURL: 'http://127.0.0.1:8000/' });

axiosInstance.interceptors.request.use((config) => {
    config.headers.Authorization = `Bearer ${localStorage.getItem('access')}`;
    return config;
});

export default axiosInstance;
