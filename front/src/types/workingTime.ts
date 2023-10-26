export interface IWorkingTime {
	id: number
	start: Date
	end: Date,
	user_id: number
}

export interface IWorkingTimeDTO {
	start: Date
	end: Date,
	user_id: number
}