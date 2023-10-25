import { useFetch } from '@/composables/fetch';
import type { IClock } from '@/types/clock';

const CLOCK_ENDPOINT = `${import.meta.env.VITE_BACK_URL}/clocks`

export function useGetAllClock() {
	return () => {
		return useFetch<IClock[]>(`GET`, CLOCK_ENDPOINT)
	}
}

export function useGetClock() {
	return (userId: number) => {
		return useFetch<IClock>('GET', `${CLOCK_ENDPOINT}/${userId}`)
	}
}

export function useClockUser() {
	return (userId: number) => {
		return useFetch<IClock>('POST', `${CLOCK_ENDPOINT}/${userId}`)
	}
}
