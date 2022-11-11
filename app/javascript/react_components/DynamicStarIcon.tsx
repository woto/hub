import * as React from 'react';
import { StarIcon as StarIconOutline } from '@heroicons/react/24/outline';
import { StarIcon as StarIconSolid } from '@heroicons/react/24/solid';

export default function DynamicStarIcon(props) {
  const { isChecked, ...rest } = props;
  if (isChecked) {
    return <StarIconSolid {...rest} />;
  }
  return <StarIconOutline {...rest} />;
}
