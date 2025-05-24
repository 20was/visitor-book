import React from 'react';
import { Message } from '../types';
import { useMessages } from '../hooks';

export const MessageList: React.FC = () => {
  const { data: messages = [], isLoading, error } = useMessages();

  if (isLoading) {
    return <div className="text-gray-500">Loading messages...</div>;
  }

  if (error) {
    return <div className="text-red-500">Error loading messages</div>;
  }

  return (
    <div className="bg-white shadow rounded-lg p-6">
      <h2 className="text-xl font-semibold mb-4">Recent Messages</h2>
      {messages.length === 0 ? (
        <p className="text-gray-500">
          No messages yet. Be the first to leave a message!
        </p>
      ) : (
        <div className="space-y-4">
          {messages.map((message) => (
            <MessageItem key={message.id} message={message} />
          ))}
        </div>
      )}
    </div>
  );
};

const MessageItem: React.FC<{ message: Message }> = ({ message }) => (
  <div className="border-b pb-4 last:border-0">
    <div className="flex justify-between items-start">
      <h3 className="font-medium text-gray-800">{message.name}</h3>
      <span className="text-xs text-gray-500">
        {new Date(message.timestamp).toLocaleString()}
      </span>
    </div>
    <p className="mt-1 text-gray-600">{message.content}</p>
  </div>
);
