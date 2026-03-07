import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useAuth } from './useAuth';
import { api } from '../lib/api';
import type { CreateTaskBody, Task } from '../types';

export function useListTasks() {
  const { user } = useAuth();

  return useQuery({
    queryKey: ['tasks'],
    queryFn: () => api.listTasks(user!.idToken),
    enabled: !!user,
  });
}

export function useTask(taskId: string, initialData?: Task) {
  const { user } = useAuth();

  return useQuery({
    queryKey: ['tasks', taskId],
    queryFn: () => api.getTask(taskId, user!.idToken),
    enabled: !!user && !!taskId,
    initialData,
  });
}

export function useCreateTask() {
  const { user } = useAuth();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (body: CreateTaskBody) => api.createTask(body, user!.idToken),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['tasks'] });
    },
  });
}
