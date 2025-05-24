import { useQuery } from '@tanstack/react-query';
import { apiClient } from '../api/client';
import { Message } from '../types';

export const useMessages = () => {
  return useQuery<Message[]>({
    queryKey: ['messages'],
    queryFn: async () => {
      const { data } = await apiClient.get('/api/messages');
      return data;
    },
  });
};
