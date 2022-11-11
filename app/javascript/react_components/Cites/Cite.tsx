import * as React from 'react';
import { ChatBubbleBottomCenterIcon } from '@heroicons/react/24/solid';
import Title from '../Timeline/Double/Title';
import Intro from '../Timeline/Double/Intro';
import Lookups from '../Timeline/Double/Lookups';
import Topics from '../Timeline/Double/Topics';
import Images from '../Timeline/Double/Images';
import Relevance from '../Timeline/Inline/Relevance';
import Sentiment from '../Timeline/Inline/Sentiment';
import MentionDate from '../Timeline/Inline/MentionDate';
import TimeAgo from '../TimeAgo';

export default function Cite(props: {
  user_image: string,
  user_name: string,
  user_path: string,
  link_url: string,
  target_url: string,
  text_start: string,
  relevance: number,
  sentiment: number,
  mention_date: Date,
  mention_title: string,
  title: any,
  intro: any,
  lookups: any,
  topics: any,
  images: any,
  created_at: Date,
}) {
  return (
    <>
      <li className="">
        <div className="tw-relative tw-pb-8">
          <span
            className="tw-absolute tw-top-5 tw-left-5 -tw-ml-px tw-h-full tw-w-0.5 tw-bg-gray-200"
            aria-hidden="true"
          />
          <div className="tw-relative tw-flex tw-items-start tw-space-x-3">
            <div className="tw-relative">
              <img
                src={props.user_image}
                className="tw-h-10 tw-w-10 tw-rounded-full tw-bg-gray-400 tw-flex tw-items-center tw-justify-center tw-ring-8 tw-ring-white"
              />
              <span className="tw-absolute -tw-bottom-0.5 -tw-right-1 tw-bg-white tw-rounded-tl tw-px-0.5 tw-py-px">
                <ChatBubbleBottomCenterIcon className="tw-h-5 tw-w-5 tw-text-gray-400" />
              </span>
            </div>
            <div className="tw-min-w-0 tw-flex-1">
              <div className="tw-text-sm">
                <a href={props.user_path} className="tw-font-medium tw-text-gray-900">
                  {props.user_name}
                </a>
                {' '}
                <span className="tw-text-xs tw-text-gray-500">
                  {props.created_at && <TimeAgo datetime={props.created_at} />}
                </span>
              </div>
              <div className="tw-mt-2 tw-text-sm tw-text-gray-700">
                <p className="">
                  Отметил
                  {' '}
                  {props.link_url
                    ? (
                      <span className="tw-text-orange-400 tw-font-medium">
                        <a href={props.link_url}>
                          {props.text_start}
                        </a>
                      </span>
                    )
                    : (
                      <span className="tw-text-black tw-font-medium">
                        {props.text_start}
                      </span>
                    )}
                  {' '}
                  в статье
                  {' '}
                  <a href={props.target_url} className="tw-font-medium">
                    { props.mention_title || 'Получаем название...' }
                  </a>

                  <Relevance relevance={props.relevance} />
                  <Sentiment sentiment={props.sentiment} />
                  <MentionDate mentionDate={props.mention_date} />
                </p>
              </div>
            </div>
          </div>
        </div>
      </li>

      <Title title={props.title} />
      <Intro intro={props.intro} />
      <Lookups lookups={props.lookups} />
      <Images images={props.images} />
      <Topics topics={props.topics} />
    </>
  );
}
