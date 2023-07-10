import * as React from 'react';
import { useCallback } from 'react';
import MentionsCore from '../Mentions/MentionsCore';
import axios from '../system/Axios';
import { MentionResponse, MentionsParamsType } from '../system/TypeScript';

export default function Mentions(
  { mentionId, searchString, sort }: MentionsParamsType,
) {
  const fetchFunction = useCallback(({
    mentionIdParam, mentionsSearchStringParam, sortParam, pageParam,
  }: {
    mentionIdParam?: number,
    mentionsSearchStringParam?: string,
    sortParam?: string,
    pageParam?: number,
     }) => axios.post<MentionResponse>('/api/mentions/index', {
       mention_id: mentionIdParam,
       page: pageParam,
       mentions_search_string: mentionsSearchStringParam,
       sort: sortParam,
     }), []);

  return (
    <MentionsCore
      kind="mentions"
      mentionId={mentionId}
      fetchFunction={fetchFunction}
      sort={sort}
      searchString={searchString}
    />
  );
}
