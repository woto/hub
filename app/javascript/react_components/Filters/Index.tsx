import * as React from 'react';
import { Fragment, useState } from 'react';
import {
  Dialog, Disclosure, Menu, Popover, Transition,
} from '@headlessui/react';
import { BarsArrowUpIcon, XMarkIcon } from '@heroicons/react/24/outline';
import Circles from './Circles';
import Search from './Search';
import AddCircle from './AddCircle';
import EditCircle from './EditCircle';
import AddEntity from './FilterEntitiesByTitle';
import Mentions from '../Mentions/Mentions';
import Sort from './Sort';

const sortOptions = [
  { name: 'Релевантность', href: '#' },
  { name: 'Дата упоминания', href: '#' },
  { name: 'Дата обнаружения', href: '#' },
];

function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

export default function Filters(props: {
  imageSrc: string,
  entityId: number,
  searchString: string,
  entityTitle: string
}) {
  const [entities, setEntities] = useState<any[]>();
  const [searchString, setSearchString] = useState(props.searchString);
  const [scrollToFirst, setScrollToFirst] = useState(false);

  return (
    <>
      <div
        className="tw-bg-neutral-100/90 tw-shadow tw-ring-1 tw-ring-gray-200 tw-backdrop-blur-sm tw-sticky tw-top-0 tw-z-20"
      >
        <div className="tw-max-w-3xl tw-mx-auto tw-px-4 tw-text-center lg:tw-px-6 lg:tw-max-w-7xl lg:tw-px-8">
          <section aria-labelledby="filter-heading" className="tw-border-t? tw-border-gray-200? tw-py-3">
            <div className="tw-flex tw-items-center tw-justify-around">
              <div className="tw-flex tw-items-center tw-space-x-2">
                <EditCircle imageSrc={props.imageSrc} />
                <AddCircle entityIds={[props.entityId]} searchString={searchString} entityTitle={props.entityTitle} />
              </div>
              <Search setSearchString={setSearchString} setScrollToFirst={setScrollToFirst} />
              <Sort />
            </div>
          </section>
        </div>
      </div>
      <Mentions searchString={searchString} entityIds={[props.entityId]} scrollToFirst={scrollToFirst} />
    </>
  );
}
