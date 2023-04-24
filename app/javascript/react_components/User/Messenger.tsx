import { EnvelopeIcon, MinusIcon, PlusIcon } from '@heroicons/react/20/solid';
import * as React from 'react';
import { useFieldArray } from 'react-hook-form';

type MessengerType = {
  defaultValues: object,
  control: any,
  register: any,
  available_messengers: String[],
  getValues: any,
  setValue: any,
  errors: any
}

export default function Messenger({
  defaultValues, control, register, available_messengers, getValues, setValue, errors,
}: MessengerType) {
  const {
    fields, append, remove, prepend,
  } = useFieldArray({
    control,
    name: 'messengers',
  });

  return (
    <div>
      {JSON.stringify(defaultValues)}
      <label htmlFor="phone-number" className="tw-block tw-text-base tw-font-medium tw-text-gray-700">
        Контакты
      </label>

      <div className="tw-flex tw-flex-col tw-space-y-5 tw-mt-1">
        {fields.map((item, index) => (
          <div key={item.id}>
            <div className="tw-flex">
              <div className="tw-flex-auto tw-mr-3 tw-relative tw-rounded-md tw-shadow-sm">
                <div className="tw-absolute tw-inset-y-0 tw-left-0 tw-flex tw-items-center">
                  <label htmlFor="country" className="tw-sr-only">
                    Country
                  </label>
                  <select
                    {...register(`messengers.${index}.type`)}
                    id="type"
                    className="focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-h-full tw-py-0 tw-pl-3 tw-pr-7 tw-border-transparent tw-bg-transparent tw-text-gray-700 sm:tw-text-sm tw-rounded-md"
                  >
                    {available_messengers.map((item) => (
                      <option key={item}>
                        {item}
                      </option>
                    ))}
                  </select>
                </div>
                <input
                  {...register(`messengers.${index}.value`)}
                  type="text"
                  id="value"
                  className="focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block tw-w-full tw-pl-36 sm:tw-text-sm tw-border-gray-300 tw-rounded-md"
                  placeholder=""
                />
              </div>
              <button
                type="button"
                onClick={() => remove(index)}
                className="tw-inline-flex tw-items-center tw-px-3 tw-py-2 tw-border tw-border-gray-300 tw-shadow-sm tw-text-sm tw-leading-4 tw-font-medium tw-rounded-md tw-text-gray-700 tw-bg-white hover:tw-bg-gray-50 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
              >
                <MinusIcon className="tw-inline tw-align-top tw-h-4 tw-w-4" />
              </button>
            </div>
            { errors.messengers?.[index.toString()] && (
            <p className="tw-mt-2 tw-text-sm tw-text-red-500">
              {
                [
                  errors.messengers[index.toString()]?.type?.message,
                  errors.messengers[index.toString()]?.value?.message,
                ].filter(Boolean).join(', ')
                }
            </p>
            )}
          </div>
        ))}
        <div>
          <button
            type="button"
            className="tw-inline-flex tw-items-center tw-px-2.5 tw-py-1.5 tw-border tw-border-transparent tw-text-xs tw-font-medium tw-rounded
             tw-text-sky-500 tw-bg-indigo-100 hover:tw-bg-indigo-200 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
            onClick={() => {
              append({ type: '', value: '' });
            }}
          >
            Добавить...
          </button>
        </div>
      </div>
    </div>
  );
}
