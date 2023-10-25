import { useFetch } from '@/composables/fetch';
import type { IWorkingTime } from '@/types/workingTime';

const WT_ENDPOINT = `${import.meta.env.VITE_BACK_URL}/workingtimes`

export function useGetAllWorkingTimes() {
	return () => {
		return useFetch<IWorkingTime[]>('GET', WT_ENDPOINT)
	}
}

export function useGetWorkingTimesForUser() {
	return (userId: number) => {
		return useFetch<IWorkingTime>('GET', `${WT_ENDPOINT}/${userId}`)
	}
}

export function useDeleteWorkingTime() {
	return (wtId: number) => {
		return useFetch('DELETE', `${WT_ENDPOINT}/${wtId}`)
	}
}