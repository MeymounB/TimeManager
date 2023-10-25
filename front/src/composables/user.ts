import { useFetch } from '@/composables/fetch';
import type { IUser, IUserDTO, IUserShort } from '@/types/user';

const USERS_ENDPOINT = `${import.meta.env.VITE_BACK_URL}/users`

export function useGetAllUser() {
	return () => {
		return useFetch<IUserShort[]>('GET', USERS_ENDPOINT)
	}
}

export function useGetUser() {
	return (userId: number) => {
		return useFetch<IUser>('GET', `${USERS_ENDPOINT}/${userId}`)
	}
}

export function useCreateUser() {
	return (newUser: IUserDTO) => {
		return useFetch<IUser>('POST', USERS_ENDPOINT, { user: newUser})
	}
}

export function useUpdateUser() {
	return (userId: number, newData: Partial<IUserDTO>) => {
		return useFetch<IUser>('PUT', `${USERS_ENDPOINT}/${userId}`, { user: newData })
	}
}

export function useDeleteUser() {
	return (userId: number) => {
		return useFetch<IUser>('DELETE', `${USERS_ENDPOINT}/${userId}`)
	}
}
