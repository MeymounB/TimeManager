import { ref } from "vue";
import type { IChartData, ITime } from "~/utils/chart";
import type { IUser } from "~/utils/user";
import type { IWorkingTime } from "~/utils/workingTime";
interface IGroupedData {
  [user_id: number]: {
    [dateIndex: number]: number;
  };
}

const colors = [
  "#FF6384",
  "#36A2EB",
  "#FFCE56",
  "#AA6384",
  "#2CA21B",
  "#FD6A02",
  "#965AA2",
  "#D982B5",
  "#2C3E50",
  "#3498DB",
  "#F39C12",
  "#16A085",
  "#2980B9",
  "#D35400",
  "#8E44AD",
  "#27AE60",
  "#C0392B",
  "#7D3C98",
  "#2E4053",
  "#1ABC9C",
  "#5499C7",
  "#AF7AC5",
  "#48C9B0",
  "#A569BD",
  "#45B39D",
  "#7D3C98",
  "#D5DBDB",
  "#283747",
  "#1B4F72",
  "#641E16",
];

export function useFormatChartDataWorkingTime() {
  return (user: IUser, workingTimes: IWorkingTime[]): IChartData => {
    const labels = ref<{ [objectId: number]: string }>({});
    const times = ref<ITime[]>([]);

    labels.value = [];
    labels.value[user.id] = user.firstname;

    times.value = workingTimes.map((workingTime) => {
      return {
        date: new Date(workingTime.start).toLocaleDateString(),
        duration:
          (new Date(workingTime.end).getTime() -
            new Date(workingTime.start).getTime()) /
          (1000 * 3600),
        objectId: workingTime?.user_id ?? user.id,
      };
    });

    const dateSet = new Set(
      times.value.map((time) => {
        return time.date;
      }),
    );

    const uniqueDates = ref<string[]>([]);

    uniqueDates.value = [...dateSet];

    const groupedData = times.value.reduce((acc: IGroupedData, time: ITime) => {
      const dateIndex = uniqueDates.value.indexOf(time.date);

      if (!acc[time.objectId])
        acc[time.objectId] = Array(uniqueDates.value.length).fill(0);

      acc[time.objectId][dateIndex] += time.duration;

      return acc;
    }, {});

    const datasets = Object.keys(groupedData).map((objectId, index) => ({
      label: labels.value[objectId as any] ?? "Unknown",
      data: groupedData[objectId as any],
      backgroundColor: colors[index % colors.length],
      fill: false,
    }));

    return {
      labels: uniqueDates.value,
      datasets: datasets as any,
    };
  };
}
