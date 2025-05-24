import { useMutation, useQueryClient } from '@tanstack/react-query';
import { apiClient } from '../api/client';
import { Message, MessageFormData } from '../types';

export const useCreateMessage = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (formData: MessageFormData) => {
      const { data } = await apiClient.post<Message>('/api/messages', formData);
      return data;
    },
    onSuccess: (newMessage) => {
      queryClient.setQueryData<Message[]>(['messages'], (old = []) => [
        newMessage,
        ...old,
      ]);
    },
  });
};
