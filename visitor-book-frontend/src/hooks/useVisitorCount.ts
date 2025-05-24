import { useQuery } from '@tanstack/react-query';
import { apiClient } from '../api/client';
import { VisitorCount } from '../types';

export const useVisitorCount = () => {
  return useQuery<VisitorCount>({
    queryKey: ['visitorCount'],
    queryFn: async () => {
      const { data } = await apiClient.get('/api/visitors');
      return data;
    },
  });
};
