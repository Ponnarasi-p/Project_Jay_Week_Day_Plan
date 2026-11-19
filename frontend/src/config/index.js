// Settings from frontend/.env (Vite only exposes variables that start with VITE_).
export const config = {
  apiBaseUrl: import.meta.env.VITE_API_BASE_URL ?? '/api',
};
