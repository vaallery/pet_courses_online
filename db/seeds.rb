# frozen_string_literal: true

require_relative 'seed'

Seed::Permissions.execute
Seed::Roles.execute
Seed::RolesPermissions.execute

puts '*** Преднаполнение таблицы Users ***'
User.fill_with [
                 { id: 1, email: 'user@example.com', password: 'secret' }
               ]

puts '*** Преднаполнение таблицы UsersRoles ***'
role = Role.find_by(name: :admin)
UsersRole.fill_with(
  [
    { id: 1, user_id: 1, role_id: role.id }
  ])

puts '*** Преднаполнение таблицы Domain ***'
Author.fill_with [
                 { id: 1, name: 'Author1' },
                 { id: 2, name: 'Author2' },
                 { id: 3, name: 'Author3' }
               ]

puts '*** Преднаполнение таблицы Courses ***'
Course.fill_with [
                   { id: 1, name: 'Course1', author_id: 1 },
                   { id: 2, name: 'Course2', author_id: 2 },
                   { id: 3, name: 'Course3', author_id: 3 },
                   { id: 4, name: 'Course4', author_id: 1 }
                 ]

puts '*** Преднаполнение таблицы Competitions ***'
Competition.fill_with(
  [
    { id: 1, name: 'Competition1' },
    { id: 2, name: 'Competition2' },
    { id: 3, name: 'Competition3' },
    { id: 4, name: 'Competition4' }
  ])

puts '*** Преднаполнение таблицы CoursesCompetitions ***'
CoursesCompetition.fill_with(
  [
    { id: 1, course_id: 1, competition_id: 1 },
    { id: 2, course_id: 1, competition_id: 2 },
    { id: 3, course_id: 1, competition_id: 3 },
    { id: 4, course_id: 1, competition_id: 4 },
    { id: 5, course_id: 2, competition_id: 2 },
    { id: 6, course_id: 3, competition_id: 3 },
    { id: 7, course_id: 4, competition_id: 4 }
  ])
