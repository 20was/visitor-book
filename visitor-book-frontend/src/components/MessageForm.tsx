import React, { useState } from 'react';
import { MessageFormData } from '../types';
import { useCreateMessage, useIncrementVisitorCount } from '../hooks';

export const MessageForm: React.FC = () => {
  const [formData, setFormData] = useState<MessageFormData>({
    name: '',
    content: '',
  });

  const createMessage = useCreateMessage();
  const incrementVisitorCount = useIncrementVisitorCount();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.name.trim() || !formData.content.trim()) {
      alert('Please fill in all fields');
      return;
    }

    try {
      await incrementVisitorCount.mutateAsync();
      await createMessage.mutateAsync(formData);
      setFormData({ name: '', content: '' });
    } catch (error) {
      console.error('Error submitting message:', error);
      alert('Failed to submit your message. Please try again.');
    }
  };

  return (
    <div className="bg-white shadow rounded-lg p-6">
      <h2 className="text-xl font-semibold mb-4">Leave a Message</h2>
      <form onSubmit={handleSubmit} className="flex flex-col md:flex-row gap-4">
        <div className="flex-1">
          <label htmlFor="name" className="block text-gray-700 mb-2">
            Your Name
          </label>
          <input
            type="text"
            id="name"
            value={formData.name}
            onChange={(e) =>
              setFormData((prev) => ({ ...prev, name: e.target.value }))
            }
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div className="flex-1">
          <label htmlFor="message" className="block text-gray-700 mb-2">
            Your Message
          </label>
          <input
            type="text"
            id="message"
            value={formData.content}
            onChange={(e) =>
              setFormData((prev) => ({ ...prev, content: e.target.value }))
            }
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>
        <div className="flex items-end">
          <button
            type="submit"
            disabled={createMessage.isPending}
            className="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:opacity-50 h-[42px]">
            {createMessage.isPending ? 'Submitting...' : 'Submit Message'}
          </button>
        </div>
      </form>
    </div>
  );
};
