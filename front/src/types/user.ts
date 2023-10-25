import type { IWorkingTime } from '@/types/workingTime';
import type { IClock } from '@/types/clock';

export interface IUserShort {
	id: number
	email: string
	username: string
}

export interface IUser extends IUserShort {
	clock: IClock
	workingTimes: IWorkingTime[]
}

export interface IUserDTO {
	email: string
	username: string
}