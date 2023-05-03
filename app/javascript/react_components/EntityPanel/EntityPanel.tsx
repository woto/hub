import * as React from 'react';
import {
  Fragment, useCallback, useReducer, useState,
} from 'react';
import {
  Dialog, Disclosure, Menu, Popover, Transition,
} from '@headlessui/react';
import { BarsArrowUpIcon, XMarkIcon } from '@heroicons/react/24/outline';
import Circles from '../Filters/Circles';
import SearchMentions from './SearchMentions';
import AddEntity from './AddEntity';
import EditEntity from './EditEntity';
import MentionsCore from '../Mentions/MentionsCore';
import SortMentions from './SortMentions';
import axios from '../system/Axios';
import { MentionResponse } from '../system/TypeScript';

const sortOptions = [
  { name: 'Релевантность', href: '#' },
  { name: 'Дата упоминания', href: '#' },
  { name: 'Дата обнаружения', href: '#' },
];

function entitiesReducer(state, action) {
  switch (action.type) {
    case 'append_entity': {
      return [...state, action.payload];
    }
    case 'remove_entity': {
      // debugger
      return state.filter((entity) => entity.entity_id !== action.payload.entity_id);
    }
    default:
      throw Error(`Unknown action: ${action.type}`);
  }
}

export function initEntities(entities: any[]) {
  return entities;
}

export default function EntityPanel(props: {
  entity: any,
  mentionsSearchString: string
}) {
  const { entity, mentionsSearchString: mentionsSearchStringProps } = props;

  const [entities, dispatchEntities] = useReducer(
    entitiesReducer,
    [entity],
    initEntities,
  );

  const [mentionsSearchString, setMentionsSearchString] = useState(mentionsSearchStringProps);
  const [scrollToFirst, setScrollToFirst] = useState(false);

  const fetchFunction = useCallback(({
    entityIdsParam, mentionsSearchStringParam, sortParam, pageParam,
  }: {
    entityIdsParam: number[],
    mentionsSearchStringParam?: string,
    sortParam?: string,
    pageParam?: number
  }) => axios.post<MentionResponse>('/api/mentions/list', {
    page: pageParam,
    entity_ids: entityIdsParam,
    mentions_search_string: mentionsSearchStringParam,
    sort: sortParam,
  }), []);

  return (
    <>
      <div
        className="tw-bg-neutral-100/90 tw-shadow tw-ring-1 tw-ring-gray-200 tw-backdrop-blur-sm tw-sticky tw-top-0 tw-z-20"
      >
        <div className="tw-max-w-3xl tw-mx-auto tw-px-4 tw-text-center lg:tw-px-6 lg:tw-max-w-7xl lg:tw-px-8">
          <section aria-labelledby="filter-heading" className="tw-border-t? tw-border-gray-200? tw-py-3">
            <div className="tw-flex tw-items-center tw-justify-around">
              <div className="tw-flex tw-items-center tw-space-x-2">
                { entities.map((item: any) => (
                  <EditEntity
                    key={item.entity_id}
                    entity={item}
                    dispatchEntities={dispatchEntities}
                  />
                ))}
                <AddEntity
                  entities={entities}
                  dispatchEntities={dispatchEntities}
                  mentionsSearchString={mentionsSearchString}
                />
              </div>
              <SearchMentions
                setMentionsSearchString={setMentionsSearchString}
                mentionsSearchString={mentionsSearchString}
                setScrollToFirst={setScrollToFirst}
              />
              <SortMentions />
            </div>
          </section>
        </div>
      </div>
      <MentionsCore
        kind="entitiesMentions"
        mentionsSearchString={mentionsSearchString}
        entityIds={entities.map((item) => item.entity_id)}
        scrollToFirst={scrollToFirst}
        fetchFunction={fetchFunction}
      />
    </>
  );
}
