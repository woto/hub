import * as React from 'react';
import { useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import {
  Link, NavLink, Navigate, Route, Routes, useNavigate,
} from 'react-router-dom';
import axios from '../system/Axios';
import Profile from './Profile';
import Email from './Email';
import ApiKey from './ApiKey';
import Password from './Password';
import useAuth from '../Auth/useAuth';
import Root from '../system/Root';
import DangerZone from './DangerZone';

const tabs = [
  { to: '/settings/profile', title: 'Профиль' },
  { to: '/settings/email', title: 'Email' },
  { to: '/settings/api_key', title: 'API key' },
  { to: '/settings/password', title: 'Password' },
  { to: '/settings/danger_zone', title: 'Danger zone' },
];

export default function Tabs(
  {
    available_languages, available_time_zones, available_messengers,
  }:
  {
    available_languages: String[], available_time_zones: String[], available_messengers: String[]
  },
) {
  const navigate = useNavigate();
  const { user: data } = useAuth();

  return (
    <div>
      <div className="sm:tw-hidden">
        <label htmlFor="tabs" className="tw-sr-only">
          Select a tab
        </label>
        <select
          id="tabs"
          name="tabs"
          className="tw-block tw-w-full tw-pl-3 tw-pr-10 tw-py-2 tw-text-base tw-border-gray-300 focus:tw-outline-none focus:tw-ring-indigo-500 focus:tw-border-indigo-500 sm:tw-text-sm tw-rounded-md"
          // defaultValue={tabs.find((tab) => tab.current).name}
          onChange={(e) => navigate(tabs[e.target.value].to)}
        >
          {tabs.map((tab, index) => (
            <option
              key={tab.to}
              value={index}
            >
              {tab.title}
            </option>
          ))}
        </select>
      </div>
      <div className="tw-hidden sm:tw-block">
        <div className="tw-border-b tw-border-gray-200">
          <nav className="-tw-mb-px tw-flex tw-space-x-8" aria-label="Tabs">

            { tabs.map((nav) => (
              <NavLink
                key={nav.to}
                to={nav.to}
                className={({ isActive }) => `
                ${isActive
                  ? 'tw-border-indigo-500 tw-text-indigo-600'
                  : 'tw-border-transparent tw-text-gray-500 hover:tw-text-gray-700 hover:tw-border-gray-300'
                }
                'tw-whitespace-nowrap tw-py-4 tw-px-1 tw-border-b-2 tw-font-medium tw-text-sm tw-cursor-pointer'
                `}
              >
                {nav.title}
              </NavLink>
            ))}
          </nav>
        </div>
      </div>

      { data
        && (
        <Routes>
          <Route path="/settings/profile" element={<Profile available_languages={available_languages} available_time_zones={available_time_zones} available_messengers={available_messengers} defaultValues={data} />} />
          <Route path="/settings/email" element={<Email defaultValues={data} />} />
          <Route path="/settings/api_key" element={<ApiKey defaultValues={data} />} />
          <Route path="/settings/password" element={<Password defaultValues={data} />} />
          <Route path="/settings/danger_zone" element={<DangerZone defaultValues={data} />} />
        </Routes>
        )}

    </div>
  );
}
