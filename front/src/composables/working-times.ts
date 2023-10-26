import { useFetch } from '@/composables/fetch';
import type { IWorkingTime, IWorkingTimeDTO } from "@/types/workingTime";

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

export function useCreateWorkingTime() {
	return (userId: number, newWt: IWorkingTimeDTO) => {
		return useFetch("POST", `${WT_ENDPOINT}/${userId}`, { 'working_time': newWt });
	}
}

export function useUpdateWorkingTime() {
	return (wtId: number, newWt: Partial<IWorkingTimeDTO>) => {
		return useFetch('PUT', `${WT_ENDPOINT}/${wtId}`,{ 'working_time': newWt } )
	}
}