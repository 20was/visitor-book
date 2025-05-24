import React from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { MessageForm } from './components/MessageForm';
import { MessageList } from './components/MessageList';
import { useVisitorCount } from './hooks';

const queryClient = new QueryClient();

const VisitorCount: React.FC = () => {
  const { data } = useVisitorCount();

  return (
    <div className="mt-4 bg-blue-50 text-blue-700 px-4 py-2 rounded-md inline-block">
      Visitor Count: <span className="font-bold">{data?.count ?? 0}</span>
    </div>
  );
};

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <div className="min-h-screen bg-gray-100">
        <div className="container mx-auto px-4 py-8">
          <header className="bg-white shadow rounded-lg mb-8 p-6">
            <h1 className="text-3xl font-bold text-gray-800">
              VisitorBook Cloud Edition
            </h1>
            <p className="text-gray-600 mt-2">
              A DevOps journey from frontend to cloud deployment
            </p>
            <VisitorCount />
          </header>

          <div className="space-y-8">
            <MessageForm />
            <MessageList />
          </div>
        </div>
      </div>
      <ReactQueryDevtools />
    </QueryClientProvider>
  );
}

export default App;
