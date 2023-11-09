export interface ITime {
  date: string;
  duration: number;
  objectId: number;
}

export interface IDataset {
  label: string;
  backgroundColor: string;
  data: { [dateIndex: number]: number };
}

export interface IChartData {
  labels: string[];
  datasets: IDataset[];
}
