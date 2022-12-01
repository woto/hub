import * as React from 'react';
import { UserInterface } from '../Auth/useAuth';

export type TagObject = {
  title: string,
  url: string | undefined
}

export type Image = {
  id: number | null,
  image_url: string | null,
  file?: File | null,
  json?: {
    data: {
      id: string,
      storage: string,
      metadata: {
        filename: string,
        size: number,
        mime_type: string,
        width: number,
        height: number
      },
    },
  },
  destroy: boolean,
}

export interface Listing {
  id: number,
  name: string,
  description: string,
  count: number,
  is_checked: boolean,
  is_public: boolean,
  is_owner: boolean,
  image: Image
}


export type CarouselType = 'one' | 'multiple';

export type DOMRectJSON = {
  x: number;
  y: number;
  top: number;
  right: number;
  bottom: number;
  left: number;
  width: number;
  height: number;
};

export interface User {
  id: number,
  email: string,
  name: string,
  avatar: string
}
export interface AuthInterface {
  user: User,
  setUser: React.Dispatch<React.SetStateAction<User>>,
}

export interface TailwindConfigInterface {
  fullConfig: any
}

export interface SidebarInterface {
  navigation: any
  sidebarOpen: boolean,
  setSidebarOpen: React.Dispatch<React.SetStateAction<boolean>>
}

type MentionImage = {
  'id': number,
  'original': string,
  'images': {
    '50': string,
    '100': string,
    '200': string,
    '300': string,
    '500': string,
    '1000': string
  },
  'videos': {
    '50': string,
    '100': string,
    '200': string,
    '300': string,
    '500': string,
    '1000': string
  },
  'width': number,
  'height': number,
  'mime_type': string,
  'dark': boolean
}

type MentionType = {
  '_index': string,
  '_type': string,
  '_id': string,
  '_score': number | null,
  '_source': {
    'id': number,
    'published_at': string | null,
    'topics': any[],
    'hostname': string,
    'url': string,
    'title': string,
    'created_at': string,
    'updated_at': string,
    'user_id': number,
    'image': MentionImage[],
    'entities': [
      {
        'id': number,
        'title': string,
        'images': MentionImage[],
        'relevance': 4,
        'sentiment': null,
        'mention_date': null,
        'created_at': '2022-09-07T15:45:30.278Z',
        'is_favorite': false
      }
    ]
  },
  'sort': number[]
}

type PaginationType = {
    'current_page': number,
    'total_pages': number,
    'limit_value': number,
    'entry_name': {
      'zero': string,
      'one': string,
      'other': string
    },
    'total_count': number,
    'offset_value': number,
    'last_page': boolean
}

type MentionResponse = {
  mentions: MentionType[]
  pagination: PaginationType
}
