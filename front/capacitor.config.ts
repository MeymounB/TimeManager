import { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "epitech.mscpar5.timemanager",
  appName: "TimeManager",
  webDir: "dist",
  plugins: {
    SplashScreen: {
      launchShowDuration: 0,
    },
  },
};

export default config;
