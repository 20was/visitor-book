import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { VisitorCount } from '../types';
import { apiClient } from '../api/client';

export const useIncrementVisitorCount = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async () => {
      const { data } = await apiClient.post<VisitorCount>('/api/visitors');
      return data;
    },
    onSuccess: (data) => {
      queryClient.setQueryData(['visitorCount'], data);
    },
  });
};
