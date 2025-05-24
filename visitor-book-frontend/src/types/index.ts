export interface Message {
  id: number;
  name: string;
  content: string;
  timestamp: string;
}

export interface VisitorCount {
  count: number;
}

export interface MessageFormData {
  name: string;
  content: string;
}
