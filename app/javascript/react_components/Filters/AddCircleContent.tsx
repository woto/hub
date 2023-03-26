import * as React from 'react';

import { Popover, Transition } from '@headlessui/react';

import {
  BookmarkIcon,
  BriefcaseIcon,
  BuildingLibraryIcon, ChevronDownIcon, ComputerDesktopIcon,
  GlobeAltIcon,
  InformationCircleIcon,
  NewspaperIcon, PlusIcon,
  ShieldCheckIcon,
  UsersIcon,
} from '@heroicons/react/24/outline';
import { useQuery } from 'react-query';
import { Fragment, useMemo, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import Entities from './Entities';
import axios from '../system/Axios';
import Entity from './Entity';
import Alert from '../Alert';
import FilterEntitiesByTitle from './FilterEntitiesByTitle';

export default function AddCircleContent(
  props:
  {entityIds: number[],
    entityTitle: string,
    q: string},
) {
  const [entityTitle, setEntityTitle] = useState(props.entityTitle || '');

  const queryKey = useMemo(() => ['addCircle', props.entityIds, props.q, entityTitle], [props.entityIds, props.q, entityTitle]);

  const {
    status, isLoading, error, data, isFetching,
  } = useQuery(
    queryKey,
    () => axios
      .post('/api/entities/related', {
        entity_ids: props.entityIds,
        q: props.searchString,
        entity_title: entityTitle,
      })
      .then((res) => res.data),
  );

  return (
    <>
      <div className="tw-sticky tw-z-10 tw-top-0 tw-p-5 tw-bg-slate-100
      tw-grid tw-grid-cols-1 tw-gap-4 sm:tw-grid-cols-2 tw-items-center"
      >
        <FilterEntitiesByTitle entityTitle={entityTitle} setEntityTitle={setEntityTitle} />
      </div>

      <div className="tw-bg-slate-100">

        <AnimatePresence mode="popLayout">
          { status === 'loading'
          && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            key="1"
            className="tw-px-5 tw-pb-5"
          >
            <Alert type="info">Загружается...</Alert>
          </motion.div>
          )}

          { status === 'error'
            && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              key="2"
              className="tw-px-5 tw-pb-5"
            >
              <Alert type="danger">Ошибка</Alert>
            </motion.div>
            )}

          { data && data.length === 0
          && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            key="4"
            className="tw-px-5 tw-pb-5"
          >
            <Alert type="danger">Ничего не найдено</Alert>
          </motion.div>
          )}

          { status === 'success' && data && data.length > 0
            && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="tw-pt-2? tw-pr-5 tw-pb-5 tw-pl-5 tw-bg-slate-100 tw-grid tw-grid-cols-1 tw-gap-4 sm:tw-grid-cols-2"
            >
              <Entities
                key="3"
                entities={data}
              />
            </motion.div>
            )}
        </AnimatePresence>
      </div>
    </>
  );
}
