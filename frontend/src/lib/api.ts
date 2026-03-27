import type { CreateTaskBody, CreateTaskResponse, DetailTaskResponse, ListTasksResponse, Task } from '../types';

const BASE_URL = import.meta.env.VITE_API_BASE_URL;

async function request<T>(
  path: string,
  options: RequestInit = {},
  idToken?: string,
): Promise<T> {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(idToken ? { Authorization: idToken } : {}),
  };

  const response = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: { ...headers, ...(options.headers as Record<string, string>) },
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export const api = {
  listTasks: (idToken: string) =>
    request<ListTasksResponse>('/tasks', { method: 'GET' }, idToken),

  createTask: (body: CreateTaskBody, idToken: string) =>
    request<CreateTaskResponse>(
      '/tasks',
      { method: 'POST', body: JSON.stringify(body) },
      idToken,
    ),

  getTask: async (id: string, idToken: string): Promise<Task | undefined> => {
    const res = await request<DetailTaskResponse>(`/tasks/${id}`, { method: 'GET' }, idToken);
    return res.task;
  },
};
