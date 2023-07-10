import * as React from 'react';
import { useCallback } from 'react';
import MentionsCore from '../Mentions/MentionsCore';
import axios from '../system/Axios';
import { ListingMentionsParamsType, MentionResponse } from '../system/TypeScript';

export default function ListingMentions(
  { listingId, sort, searchString }: ListingMentionsParamsType,
) {
  const fetchFunction = useCallback(({
    listingIdParam, mentionsSearchStringParam, sortParam, pageParam,
  }: {
    listingIdParam?: number,
    mentionsSearchStringParam?: string,
    sortParam?: string,
    pageParam?: number
  }) => axios.post<MentionResponse>('/api/mentions/index', {
    listing_id: listingIdParam,
    page: pageParam,
    mentions_search_string: mentionsSearchStringParam,
    sort: sortParam,
  }), []);

  return (
    <MentionsCore
      kind="listingMentions"
      listingId={listingId}
      fetchFunction={fetchFunction}
      sort={sort}
      searchString={searchString}
    />
  );
}
