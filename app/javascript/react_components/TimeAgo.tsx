import * as React from 'react';
import {useEffect, useState} from 'react'
import {Fragment} from 'react'
import {Popover, Transition} from '@headlessui/react'
import {FireIcon, StarIcon} from "@heroicons/react/solid";

import * as dayjs from 'dayjs';
// import utc from 'dayjs/plugin/utc';
// import timezone from 'dayjs/plugin/timezone';
import * as relativeTime from 'dayjs/plugin/relativeTime';

// Temporary there is a problem with dynamic import
// https://github.com/rails/webpacker/issues/3075
import 'dayjs/locale/ru.js'
import 'dayjs/locale/en.js'

dayjs.extend(relativeTime);

export default function TimeAgo(props: { datetime: Date }) {
  const [beautifiedDate, setBeautifiedDate] = useState(true);

  const beautifyDate = (datetime) => {
    let locale = document.documentElement.lang;
    dayjs.locale(locale);
    return dayjs(datetime).fromNow()
  }

  return (
    <span
      onClick={() => setBeautifiedDate((prevVal) => !prevVal)}
      className="tw-cursor-pointer">
      { beautifiedDate ? beautifyDate(props.datetime) : props.datetime.toString() }
    </span>
  )
}